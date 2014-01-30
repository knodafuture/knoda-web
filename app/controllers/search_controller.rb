class SearchController < ApplicationController
	before_filter :authenticate_user!
  
  def index
    if params[:q]
      limit = 5
      param_offset = 0
      @users = []
      @searchResults = User.search params[:q], fields: [:username], page: param_offset.to_i.fdiv(limit.to_i), per_page: limit, misspellings: {distance:1}, partial: true
      @searchResults.each do |u|
        @users << u.to_model
      end
      limit = 50
      @predictions = []
      @searchResults = Prediction.search params[:q], page: param_offset.to_i.fdiv(limit.to_i), per_page: limit, misspellings: {distance:2}, partial: true
      @searchResults.each do |p|
        @predictions << p.to_model
      end    
    end
  end
end