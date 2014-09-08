class HomeController < ApplicationController

  def index
    if user_signed_in?
      if current_user.avatar?
        params.delete :action
        params.delete :controller
        redirect_to :controller => 'predictions', :action => 'index', :params => params
      else
        redirect_to "/users/me/avatar"
      end
    else
      if params[:invitation_code]
        @destination = "/invitations/accpt?invitation_code=#{params[:invitation_code]}"
      end
      if Rails.cache.exist?("scoredPredictions_home")
        @scoredPredictions = Rails.cache.read("scoredPredictions_home")
      else
        @scoredPredictions = ScoredPrediction.all.to_a
        Rails.cache.write("scoredPredictions_home", @scoredPredictions, timeToLive: 1.hours)
      end
      render :layout => 'home'
    end
  end

  def about
    render :layout => 'home'
  end

  def privacy
    render :layout => 'home'
  end

  def terms
    render :layout => 'home'
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

  def embedDemo
    @prediction1 = Prediction.order('RANDOM()').first()
    @prediction2 = Prediction.where(:is_closed => true).order('RANDOM()').first()
    @prediction3 = Prediction.where(:is_closed => false).order('RANDOM()').first()
    render :layout => false
  end

  def socialDemo
    render :layout => false
  end

  def embed_login
    render :layout => false
  end

  def sitemap
    AWS.config(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    )
    bucket_name = ENV['S3_BUCKET_NAME']
    s3 = AWS::S3.new
    key = 'sitemaps/sitemap.xml.gz'
    blob =  s3.buckets[bucket_name].objects[key].read
    send_data( blob)
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
        RestClient.get("http://www.google-analytics.com/collect", params: params, timeout: 4, open_timeout: 4)
        return true
      rescue  RestClient::Exception => rex
        puts rex
        return false
      end
    end
end
