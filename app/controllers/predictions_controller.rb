class PredictionsController < AuthenticatedController
  
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:share, :show]
  skip_before_action :unseen_activities, only: [:share, :show]
  before_action :set_prediction, only: [:show, :edit, :update, :destroy, :close, :tally, :share, :share_dialog, :comments, :bs]
  
  def share
    if user_signed_in?
      redirect_to  action: 'show', id: @prediction.id
    else
      @prediction = Prediction.find(params[:id])
      render 'share', :layout => 'prelogin'
    end
  end

  def index
    if params[:tag]
      @predictions = Prediction.recent.latest.tagged_with(params[:tag]).offset(param_offset).limit(param_limit)
    else
      @predictions = Prediction.includes(:user,:comments).recent.latest.offset(param_offset).limit(param_limit)
    end
    if param_offset.to_i > 0
      render :partial => "predictions"
    else
      @unseen_badges = current_user.badges.unseen
      render 'index'
      @unseen_badges.update_all(seen: true)
    end
  end  

  # GET /predictions/1
  # GET /predictions/1.json
  def show
    if not user_signed_in?
      redirect_to action: 'share', id: @prediction.id
    else
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
    render layout: false
  end

  # GET /predictions/1/edit
  def edit
  end


  # POST /predictions
  # POST /predictions.json
  def create
    @prediction = current_user.predictions.create(prediction_params)      
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
      if @prediction.update(prediction_params)
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
    authorize_action_for(@prediction)
    close_as = prediction_close_params[:outcome]
    if @prediction.close_as(close_as)
      render json: @prediction, status: 201
    else
      render json: @prediction.errors, status: 422
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prediction
      @prediction = Prediction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prediction_params
      params.require(:prediction).permit(:body, :expires_at, :resolution_date, :tag_list)
    end    

    def prediction_close_params
      params.require(:prediction).permit(:outcome)
    end
end
