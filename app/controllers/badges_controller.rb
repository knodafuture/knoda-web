class BadgesController < AuthenticatedController
  before_filter :authenticate_user!
  before_action :set_badge, only: [:show, :edit, :update, :destroy]

  # GET /badges
  # GET /badges.json
  def index
    @badges = current_user.badges
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_badge
      @badge = Badge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def badge_params
      params[:badge]
    end
end
