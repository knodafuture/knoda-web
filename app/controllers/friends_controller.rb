class FriendsController < AuthenticatedController

  def find
    if params[:source] == 'twitter'
      if current_user.twitter_account
        @friends = current_user.twitter_friends_on_knoda(true)
      end
    else
      if current_user.facebook_account
        @friends = current_user.facebook_friends_on_knoda(true)
      end
    end
  end
end
