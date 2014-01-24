class AuthenticatedController < ApplicationController

  before_filter :unseen_activities

  def unseen_activities
  	s = current_user.activities.unseen.size
  	if s > 0
  		@unseen_activities = s
  	end
  end
end
