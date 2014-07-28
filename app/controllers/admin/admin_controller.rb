class Admin::AdminController < ApplicationController
  before_filter :admin_required #:create_prediction

  protected
    def admin_required
      if not current_user.is_admin?
        redirect_to '/'
      end
    end
end
