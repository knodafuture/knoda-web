class FriendsController < AuthenticatedController

  def find
    if params[:source] == 'twitter'
      @source = 'twitter'
      if current_user.twitter_account
        @friends = current_user.twitter_friends_on_knoda(true)
        h = { :url => 'http://www.knoda.com', :via => 'KNODAfuture', :text => "I'm on Knoda.  Start following me to see all of my predictions."}
        @twitterShareLink = "https://twitter.com/intent/tweet?#{h.to_param}"
      end
    else
      @source = 'facebook'
      if current_user.facebook_account
        @friends = current_user.facebook_friends_on_knoda(true)
      end
    end
  end
end
