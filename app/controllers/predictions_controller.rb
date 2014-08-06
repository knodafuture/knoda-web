class PredictionsController < AuthenticatedController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:share, :show, :embed]
  skip_before_action :unseen_activities, only: [:share, :show, :embed]
  before_action :set_prediction, only: [:show, :edit, :update, :destroy, :close, :tally, :share, :share_dialog, :comments, :bs, :facebook_share, :twitter_share, :embed]
  after_action :after_close, only: [:close]

  def share
    if user_signed_in?
      redirect_to  action: 'show', id: @prediction.id
    else
        @prediction = Prediction.find(params[:id])
        if (@prediction.group)
          raise ActionController::RoutingError.new('Not Found')
        else
          render 'share', :layout => 'home'
        end
    end
  end

  def embed
    @user = current_user
    response.headers["X-XSS-Protection"] = "0"
    render 'embed', :layout => false
  end

  def index
    if params[:tag]
      @predictions = Prediction.recent.latest.visible_to_user(current_user.id).where("'#{params[:tag]}' = ANY (tags)").offset(param_offset).limit(param_limit)
    else
      @predictions = Prediction.includes(:user,:comments).visible_to_user(current_user.id).recent.latest.offset(param_offset).limit(param_limit)
    end
    if param_offset.to_i > 0
      render :partial => "predictions"
    else
      render 'index'
    end
  end

  # GET /predictions/1
  # GET /predictions/1.json
  def show
    if not user_signed_in?
      redirect_to action: 'share', id: @prediction.id
    else
      authorize_action_for(@prediction)
      authenticate_user!
      unseen_activities()
      @agreeUsers = User.joins(:challenges).where(challenges: { prediction: @prediction, agree: true})
      @disagreeUsers = User.joins(:challenges).where(challenges: { prediction: @prediction, agree: false})
      render 'show'
    end
  end

  # GET /predictions/new
  def new
    @prediction = Prediction.new
    @groups = current_user.groups
    if params[:group_id]
      @default_group = Group.find(params[:group_id])
    end
    render layout: false
  end

  # GET /predictions/1/edit
  def edit
  end


  # POST /predictions
  # POST /predictions.json
  def create
    p = prediction_params

    p[:tags] = [p[:tags]]
    puts "BLAH"
    puts p
    @prediction = current_user.predictions.create(p)
    respond_to do |format|
      if @prediction.save
        format.html { redirect_to action: 'index' }
        format.json { render action: 'show', status: :created, location: @prediction }
      else
        format.html { render action: 'new' }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /predictions/1
  # PATCH/PUT /predictions/1.json
  def update
    respond_to do |format|
      authorize_action_for(@prediction)
      p = prediction_params
      p[:activity_sent_at] = nil
      Activity.where(user_id: @prediction.user.id, prediction_id: @prediction.id, activity_type: 'EXPIRED').delete_all
      if @prediction.update(p)
        format.html { redirect_to @prediction, notice: 'Prediction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /predictions/1
  # DELETE /predictions/1.json
  def destroy
    @prediction.destroy
    respond_to do |format|
      format.html { redirect_to predictions_url }
      format.json { head :no_content }
    end
  end

  def close
    respond_to do |format|
      authorize_action_for(@prediction)
      close_as = prediction_close_params[:outcome]
      if @prediction.close_as(close_as)
        format.json { render json: @prediction, status: 201 }
        format.html { render :partial => 'section2', :locals => { prediction: @prediction} }
      else
        render json: @prediction.errors, status: 422
      end
    end
  end

  # GET /prediction/1/tally.json
  def tally
    @agreeUsers = User.joins(:challenges).where(challenges: { prediction: @prediction, agree: true})
    @disagreeUsers = User.joins(:challenges).where(challenges: { prediction: @prediction, agree: false})
    render :partial => "tally"
  end

  # GET /prediction/1/share
  def share_dialog
    render :partial => "share", :locals => {:prediction => @prediction}
  end

  # GET /predictions/1/comments
  def comments
    render :partial => 'comments', :locals => {:comments => @prediction.comments}
  end

  def bs
    authorize_action_for(@prediction)
    @challenge = current_user.challenges.where(prediction: @prediction).first
    @challenge.update(bs: true)
    if not @challenge.is_own
      @challenge.prediction.request_for_bs
    else
      @challenge.prediction.revert
    end
    head :no_content
  end

  def facebook_share
    FacebookWorker.perform_in(5.seconds, current_user.id,@prediction.id, false)
    head :no_content
  end

  def twitter_share
    TwitterWorker.perform_in(5.seconds, current_user.id,@prediction.id, false)
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prediction
      @prediction = Prediction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prediction_params
      params.require(:prediction).permit(:body, :expires_at, :resolution_date, :tags, :group_id, :contest_id, :contest_stage_id)
    end

    def prediction_close_params
      params.require(:prediction).permit(:outcome)
    end

    def after_close
      PredictionClose.perform_async(@prediction.id)
    end
end
