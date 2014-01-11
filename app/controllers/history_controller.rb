class HistoryController < ApplicationController
  before_filter :authenticate_user!

  def index
    @challenges = current_user.challenges.ownedAndPicked.offset(param_offset).limit(param_limit)
    if param_offset.to_i > 0
      render :partial => "history_items"
    else
      render 'index'
    end    
  end
end
