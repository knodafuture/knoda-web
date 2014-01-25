class PredictionsController < AuthenticatedController
  
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:share]
  skip_before_action :unseen_activities, only: [:share]
  before_action :set_prediction, only: [:show, :edit, :update, :destroy, :close, :tally, :share, :share_dialog]
  
  def share
    @prediction = Prediction.find(params[:id])
    render 'share', :layout => false
  end

  def index
    @predictions = Prediction.recent.latest.offset(param_offset).limit(param_limit)
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
    @agreeUsers = User.joins(:challenges).where(challenges: { prediction: @prediction, agree: true})
    @disagreeUsers = User.joins(:challenges).where(challenges: { prediction: @prediction, agree: false}) 
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
