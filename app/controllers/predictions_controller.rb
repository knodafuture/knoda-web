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
end
