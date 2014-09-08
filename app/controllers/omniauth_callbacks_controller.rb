class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def twitter
		auth = request.env["omniauth.auth"]
		if user_signed_in?
			@social_account = current_user.social_accounts.create({
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
				destination = request.env['omniauth.params']['destination'] || "/users/me"
				if @social_account.errors
					h = { :error => @social_account.errors['user_facing'][0]}
					redirect_to "#{destination}?#{h.to_param}"
				else
					redirect_to destination
				end
			end
		else
			twitter_new(auth)
		end
	end

	def facebook
		auth = request.env["omniauth.auth"]
		if user_signed_in?
			@social_account = current_user.social_accounts.create({
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
				destination = request.env['omniauth.params']['destination'] || "/users/me"
				if @social_account.errors
					h = { :error => @social_account.errors['user_facing'][0]}
					redirect_to "#{destination}?#{h.to_param}"
				else
					redirect_to destination
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
			provider_account_name: auth.info.email,
			signup_source: request.env['omniauth.params']['signup_source']
		})

		if @user.errors and @user.errors.count > 0
			h = {}
			if self.resource.errors.include?(:email)
				h[:error] = "This email address is already registered. If you own this account, please login and connect to Facebook or Twitter in your profile."
			end
			redirect_to "#{redirect_path(h)}"
		else
			#Checks to see if the user is just logging in or has just signed up.
			if (@user.created_at <= (Time.now - 1.minutes))
				@flogin = true
			else
				@fsignup = true
			end
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
			provider_account_name: auth.info.nickname,
			signup_source: request.env['omniauth.params']['signup_source']
		})

		if (@user.created_at <= (Time.now - 1.minutes))
			@signup = false
		else
			@signup = true
		end

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

	def redirect_path(redirect_options)
		h = add_analytics(redirect_options)
		if request.env['omniauth.params']['popup_window']
			redirect_options[:close] = 'true'
			return "/embed-login?#{redirect_options.to_param}"
		else
			url = request.env['omniauth.origin'] || stored_location_for(resource) || root_path
			return "#{url}?#{redirect_options.to_param}"
		end
	end

	def add_analytics(h)
		if (@signup)
			h[:ANALYTICS_EVENT] = "SIGNUP_TWITTER"
		end
		if (!@signup)
			h[:ANALYTICS_EVENT] = "LOGIN_TWITTER"
		end
		if (@fsignup)
			h[:ANALYTICS_EVENT] = "SIGNUP_FACEBOOK"
		end
		if (@flogin)
			h[:ANALYTICS_EVENT] = "LOGIN_FACEBOOK"
		end

		return h
	end

end
