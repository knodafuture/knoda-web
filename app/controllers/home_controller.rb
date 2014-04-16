class HomeController < ApplicationController

  def index
    if user_signed_in?
      if current_user.avatar?
        redirect_to :controller => 'predictions', :action => 'index'
      else
        redirect_to "/users/me/avatar"
      end
    else
      @scoredPredictions = ScoredPrediction.all
      render :layout => 'home'
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
        server_side('redirect', 'app_store')
        redirect_to "https://itunes.apple.com/us/app/knoda/id764642995"
      elsif browser_is?("android")
        server_side('redirect', 'play_store')
        redirect_to "https://play.google.com/store/apps/details?id=com.knoda.knoda"
      else
        redirect_to '/'
      end
    rescue
      redirect_to '/'
    end
  end

  private
    def server_side(category, action, client_id = '555')
      puts 'code?'
      params = {
        v: 1,
        tid: "UA-47440970-1",
        cid: client_id,
        t: "event",
        ec: category,
        ea: action
      }

      begin
        puts params
        RestClient.get("http://www.google-analytics.com/collect", params: params, timeout: 4, open_timeout: 4)
        return true
      rescue  RestClient::Exception => rex
        puts rex
        return false
      end
    end
end
