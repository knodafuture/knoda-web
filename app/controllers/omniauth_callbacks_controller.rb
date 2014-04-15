class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def twitter
  		auth = request.env["omniauth.auth"]
  		@user = User.find_or_create_from_social(
    	{
	      provider_name: auth.provider,
	      provider_id: auth.uid,
	      access_token: auth.credentials.token,
	      access_token_secret: auth.credentials.secret,
	      username: auth.info.nickname,
	      image: auth.info.image
	    })
  		sign_in_and_redirect @user, :event => :authentication
  	end

  	def facebook
  		auth = request.env["omniauth.auth"]
  		@user = User.find_or_create_from_social(
    	{
	      provider_name: auth.provider,
	      provider_id: auth.uid,
	      access_token: auth.credentials.token,
	      email: auth.info.email,
	      username: auth.info.first_name + auth.info.last_name,
	      image: auth.info.image
	    })
  		sign_in_and_redirect @user, :event => :authentication
  	end
end