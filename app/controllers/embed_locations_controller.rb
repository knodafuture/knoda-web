class EmbedLocationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def create
    p = embed_location_params
    if p[:contest_id]
      @embed_location = EmbedLocation.where(:url => p[:url], :contest_id => p[:contest_id]).first_or_initialize
    elsif p[:prediction_id]
      @embed_location = EmbedLocation.where(:url => p[:url], :prediction_id => p[:prediction_id]).first_or_initialize
    end
    @embed_location.save
    render :json => @embed_location
  end

  private
    def embed_location_params
      params.permit(:contest_id, :prediction_id, :url)
    end

end
