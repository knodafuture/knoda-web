class PredictionsController < ApplicationController
  def show
    @prediction = Prediction.find(params[:id])
  end
end
