class ContestsController < AuthenticatedController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:embed]
  before_action :set_contest

  def embed
    @user = current_user
    response.headers["X-XSS-Protection"] = "0"
    render 'embed', :layout => false
  end

private
  def set_contest
    @contest = Contest.find(params[:id])
  end
end
