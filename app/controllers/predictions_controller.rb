class PredictionsController < ApplicationController
  def showShared
    @prediction = Prediction.find(params[:id])
    @prediction
  end
end
