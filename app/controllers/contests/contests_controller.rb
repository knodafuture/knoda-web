class Contests::ContestsController < ApplicationController
  before_filter :admin_required

  def create_contest
      @contest = current_user.contests.create(contests_params)
  end


  protected
    def admin_required
      if not current_user.is_admin?
        redirect_to '/'
      end
    end

  private
      def contests_params
        params.permit(:name, :description, :avatar, :detail_url, :rules_url, :crop_x, :crop_y, :crop_w, :crop_h)
      end
end
