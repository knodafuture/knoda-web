class SearchController < ApplicationController
	before_filter :authenticate_user!

  def index
    if params[:q]
			@users = []
			@predictions = []
			if not params[:hashtag]
	      limit = 5
	      param_offset = 0
	      @searchResults = User.search params[:q], fields: [{username: :text_start}], page: param_offset.to_i.fdiv(limit.to_i), per_page: limit, misspellings: {distance:1}, partial: true, boost: "points"
	      @searchResults.each do |u|
	        @users << u.to_model
	      end
			end
      limit = 50
      @searchResults = Prediction.search params[:q], fields: [ {body: :word}, {tags: :word}], page: param_offset.to_i.fdiv(limit.to_i), per_page: limit, misspellings: {distance:2}, partial: true, boost: "challenge_count"
      @searchResults.each do |p|
        m = p.to_model
        if !m.group_id or current_user.memberships.pluck(:group_id).include?(m.group_id)
          @predictions << m
        end
      end
    end
  end
end
