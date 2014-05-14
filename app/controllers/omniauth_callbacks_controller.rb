class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def twitter
		auth = request.env["omniauth.auth"]
		if user_signed_in?
			a = current_user.social_accounts.create({
				:provider_name => auth.provider,
				:provider_id => auth.uid,
				:access_token => auth.credentials.token,
				:access_token_secret => auth.credentials.secret,
				:provider_account_name => auth.info.nickname
			})
			if request.env['omniauth.params']['popup']
				@provider_name = auth.provider
				render "popup", layout: false
			else
				if a.errors
					h = { :error => a.errors['user_facing'][0]}
					redirect_to "/users/me?#{h.to_param}"
				else
					redirect_to "/users/me"
				end
			end
		else
			twitter_new(auth)
		end
	end

  	def facebook
  		auth = request.env["omniauth.auth"]
			if user_signed_in?
				a = current_user.social_accounts.create({
					:provider_name => auth.provider,
					:provider_id => auth.uid,
					:access_token => auth.credentials.token,
					:access_token_secret => auth.credentials.secret,
					:provider_account_name => auth.info.nickname
				})
				if request.env['omniauth.params']['popup']
					@provider_name = auth.provider
					@social_account = a
					render "popup", layout: false
				else
					if a.errors
						h = { :error => a.errors['user_facing'][0]}
						redirect_to "/users/me?#{h.to_param}"
					else
						redirect_to "/users/me"
					end
				end
			else
				facebook_new(auth)
			end
  	end


	def after_sign_in_path_for(resource)
		redirect_path({})
	end

private
	def facebook_new(auth)
		@user = User.find_or_create_from_social(
		{
			provider_name: auth.provider,
			provider_id: auth.uid,
			access_token: auth.credentials.token,
			email: auth.info.email,
			username: auth.info.first_name + auth.info.last_name,
			image: auth.info.image,
			provider_account_name: auth.info.email
		})
		if @user.errors and @user.errors.count > 0
			h = {}
			if self.resource.errors.include?(:email)
				h[:error] = "This email address is already registered. If you own this account, please login and connect to Facebook or Twitter in your profile."
			end
			redirect_to "#{redirect_path(h)}"
		else
			sign_in_and_redirect @user, :event => :authentication
		end
	end

	def twitter_new(auth)
		@user = User.find_or_create_from_social(
		{
			provider_name: auth.provider,
			provider_id: auth.uid,
			access_token: auth.credentials.token,
			access_token_secret: auth.credentials.secret,
			username: auth.info.nickname,
			image: auth.info.image,
			provider_account_name: auth.info.nickname
		})
		if @user.errors and @user.errors.count > 0
			h = {}
			if self.resource.errors.include?(:email)
				h[:error] = "This email address is already registered. If you own this account, please login and connect to Facebook or Twitter in your profile."
			end
			redirect_to "#{redirect_path(h)}"
		else
			sign_in_and_redirect @user, :event => :authentication
		end
	end

	def redirect_path(h)
		if request.env['omniauth.params']['embed']
			h[:close] = 'true'
			return "/embed-login?#{h.to_param}"
		else
			url = request.env['omniauth.origin'] || stored_location_for(resource) || root_path
			return "url?#{h.to_param}"
		end
	end
end
