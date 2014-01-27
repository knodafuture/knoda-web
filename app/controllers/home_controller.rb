class HomeController < ApplicationController

  def index
    if user_signed_in?
      if current_user.avatar?
        redirect_to :controller => 'predictions', :action => 'index'
      else
        redirect_to "/users/#{current_user.id}/avatar"
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
    if browser_is?("ios")
      redirect_to "https://itunes.apple.com/us/app/knoda/id764642995"
    else
      index()
    end
  end
end
