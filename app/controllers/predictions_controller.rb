class PredictionsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:showShared]
  
  def showShared
    @prediction = Prediction.find(params[:id])
    @prediction
  end

  def feed
    @predictions = Prediction.all
    puts @predictions.length
    @predictions
  end  

  # GET /predictions/1
  # GET /predictions/1.json
  def show
    @prediction = Prediction.find(params[:id])
    @prediction    
  end

  # GET /predictions/new
  def new
    @prediction = Prediction.new
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
        format.html { redirect_to action: 'feed' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prediction
      @prediction = Prediction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prediction_params
      params.require(:prediction).permit(:body, :expires_at, :resolution_date )
    end    
end
