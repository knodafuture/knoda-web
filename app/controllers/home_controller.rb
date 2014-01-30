class HomeController < ApplicationController

  def index
    if user_signed_in?
      if current_user.avatar?
        redirect_to :controller => 'predictions', :action => 'index'
      else
        redirect_to "/users/me/avatar"
      end
    else
      render :layout => 'prelogin'
    end
  end

  def about
    render :layout => 'prelogin'
  end

  def privacy
    render :layout => 'prelogin'
  end

  def terms
    render :layout => 'prelogin'
  end

  def start
    begin
      if browser_is?("ios")
        redirect_to "https://itunes.apple.com/us/app/knoda/id764642995"
      else
        redirect_to '/'
      end
    rescue
      redirect_to '/'
    end
  end
end
