class GroupsController < AuthenticatedController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:join]
  skip_before_action :unseen_activities, only: [:join]
  before_action :set_group, only: [:show, :edit, :update, :destroy, :settings, :leaderboard, :invite, :avatar, :crop, :default_avatar, :avatar_upload]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups
    render 'index'
  end

  def show
    @predictions = Prediction.recent.latest.for_group(@group.id).offset(param_offset).limit(param_limit)
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
        format.html { render :action => 'settings'}
        format.json { render json: @group }
      else
        format.json { render json: @group.errors, status: :unprocessable_entity }
        format.html { render :action => 'settings'}
      end
    end
  end

  def leaderboard
    if params[:board] == 'monthly'
      @leaders = Group.weeklyLeaderboard(@group)
    elsif params[:board] == 'alltime'
      @leaders = Group.monthlyLeaderboard(@group)
    else
      @leaders = Group.allTimeLeaderboard(@group)
    end
    @leaders.each do |l|
      puts l
    end
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

  def avatar
    @avatar_version = 1 + rand(5)
  end

  def avatar_upload
    @group.avatar = params[:file]
    @group.save
    render :json => {success: false}, :status => :ok
  end

  def default_avatar
    av = params[:avatar_version] || (1 + rand(5))
    p = Rails.root.join('app', 'assets', 'images', 'avatars', "avatar_#{av}@2x.png")
    @group.avatar_from_path p
    @group.save
    redirect_to "/groups/#{params[:id]}"
  end  

  def crop
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
