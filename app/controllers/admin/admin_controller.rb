class Admin::AdminController < ApplicationController
  before_filter :admin_required
  protected
    def admin_required
      authenticate_or_request_with_http_basic do |user_name, password|
        user_name == 'admin' && password == 'knoda'
      end
    end
end
