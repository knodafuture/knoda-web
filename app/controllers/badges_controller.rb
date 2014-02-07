class BadgesController < AuthenticatedController
  before_filter :authenticate_user!
  before_action :set_badge, only: [:show, :edit, :update, :destroy]

  # GET /badges
  # GET /badges.json
  def index
    if params[:unseen]
      @badges = current_user.badges.unseen
    else
      @badges = current_user.badges
    end
    respond_to do |format|
      if params[:modal]
        format.html { 
          render :partial => 'unseen_modal', :locals => {unseen_badges: @badges} 
          @badges.update_all(seen: true)
        }
        format.json { 
          render :json => @badges
        }
      else
        format.html { 
          render 'index' 
        }
        format.json { 
          render :json => @badges
        }
      end
    end
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
