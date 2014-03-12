class GroupsController < AuthenticatedController
  before_filter :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy, :settings, :leaderboard, :invite]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups
    render 'index'
  end

  def show
    @predictions = Prediction.recent.latest.for_group(@group.id)
    @user = current_user
    @leaders = Group.weeklyLeaderboard(@group)
    render 'show'
  end

  def new
    @group = Group.new
    render layout: false
  end

  def create
    @group = current_user.groups.create(group_params)
    current_user.memberships.where(:group_id => @group.id).first.update(role: 'OWNER')    
    render :json => @group
  end  

  def leaderboard
    @leaders = Group.weeklyLeaderboard(@group)
  end

  def settings
    if @group.owned_by?(current_user)
      render 'settings'
    else
      redirect_to("/groups/#{@group.id}")
    end
  end

  def invite
    render :partial => "invite", :locals => {:group => @group}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :description, :avatar)
    end        
end
