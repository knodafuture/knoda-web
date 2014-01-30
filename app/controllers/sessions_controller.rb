class SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_to do |format|
    	format.json {
    		render :json => resource
    	}
    	format.html {
    		respond_with resource, :location => after_sign_in_path_for(resource)
    	}
    end
  end

  protected
  def auth_options
    { :scope => resource_name, :recall => "#{controller_path}#new" }
  end
end