class GroupsController < AuthenticatedController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:join]
  skip_before_action :unseen_activities, only: [:join]
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

  def update
    respond_to do |format|
      authorize_action_for(@group)
      puts group_params
      if @group.update(group_params)
        format.json { render json: @group }
      else
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
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

  def join
    @invitation = Invitation.where(:code => params[:code]).first
    if user_signed_in?
      if current_user.memberships.where(:group_id => @invitation.group_id).size > 0
        redirect_to("/groups/#{@invitation.group_id}")
      else
        render 'join'
      end
    else
      render 'join_login', :layout => 'invitation'
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
