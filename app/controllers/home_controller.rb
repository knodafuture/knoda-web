class HomeController < ApplicationController

  def index
    if user_signed_in?
      puts current_user
      if current_user.avatar?
        redirect_to :controller => 'predictions', :action => 'index'
      else
        redirect_to "/users/#{current_user.id}/avatar"
      end
    else
      render layout: "prelogin"
    end
  end

  def about
    render layout: false
  end

  def privacy
    render layout: false
  end

  def terms
    render layout: false
  end
end
