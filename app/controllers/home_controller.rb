class HomeController < ApplicationController

  def index
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'cudeJl428sK15geAzUZ8Rw'
      config.consumer_secret = 'YWr0FFuRmhSqdk66Fs1rVV0kQIyrW7DxHoERP4LWws'
      config.oauth_token = '1394859757-dNKz3QuO1R5iiEaf8oR8RDpVzbCRWUKAlzp5Uw0'
      config.oauth_token_secret = 'bVbL3Y0fEJzvpHkh6kyW3AHRbBNraf1lS9xbQQghk'
    end    
    @t = client.user_timeline('knodafuture')
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

  def new
    if user_signed_in?
      redirect_to :controller => 'predictions', :action => 'feed'
    else
      render layout: "prelogin"
    end
  end
end
