class GroupsController < AuthenticatedController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:join]
  skip_before_action :unseen_activities, only: [:join]
  before_action :set_group, only: [:show, :edit, :update, :destroy, :settings, :leaderboard, :invite, :avatar, :crop, :avatar_upload, :share, :predictions]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups
    @contests = Contest.entered_by_user(current_user.id)
    @contests_explore = Contest.not_entered_by_user(current_user.id).order('created_at desc')
    render 'index'
  end

  def show
    authorize_action_for @group
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
    if @group.avatar.blank?
      av = (1 + rand(5))
      p = Rails.root.join('app', 'assets', 'images', 'avatars', "groups_avatar_#{av}@2x.png")
      @group.avatar_from_path p
      @group.save
    end
    current_user.memberships.where(:group_id => @group.id).first.update(role: 'OWNER')
    render :json => @group
  end

  def update
    respond_to do |format|
      authorize_action_for(@group)
      if @group.update_attributes(group_params)
        if params[:group][:avatar].blank? and @group.cropping?
          @group.reprocess_avatar
        end
        format.html {
          redirect_to "/groups/#{@group.id}/settings"
        }
        format.json { render json: @group }
      else
        format.json { render json: @group.errors, status: :unprocessable_entity }
        format.html {
          redirect_to "/groups/#{@group.id}/settings"
        }
      end
    end
  end

  def leaderboard
    if current_user.can_read?(@group)
      if params[:board] == 'monthly'
        @leaders = Group.monthlyLeaderboard(@group)
      elsif params[:board] == 'alltime'
        @leaders = Group.allTimeLeaderboard(@group)
      else
        @leaders = Group.weeklyLeaderboard(@group)
      end
    else
      render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    end
  end

  def settings
    if current_user.can_read?(@group)
      @memberships = @group.memberships.joins(:user).where('user_id != ?', current_user.id).order("users.username ASC")
      render 'settings'
    else
      render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    end
  end

  def join
    if params[:code]
      @destination = "/groups/join?code=#{params[:code]}"
      @invitation = Invitation.where(:code => params[:code]).first
      @group = @invitation.group
    elsif params[:id]
      @destination = "/groups/join?id=#{params[:id]}"
      @group = Group.where(:share_id => params[:id]).first
    end
    @owner = @group.owner

    if user_signed_in?
      if current_user.memberships.where(:group_id => @group.id).size > 0
        redirect_to("/groups/#{@group.id}")
      else
        render 'join'
      end
    else
      if Rails.cache.exist?("scoredPredictions_home")
        @scoredPredictions = Rails.cache.read("scoredPredictions_home")
      else
        @scoredPredictions = ScoredPrediction.all.to_a
        Rails.cache.write("scoredPredictions_home", @scoredPredictions, timeToLive: 1.hours)
      end
      @groupInvitation = true
      render "home/index", :layout => 'home'
    end
  end

  def invite
    render :partial => "invite", :locals => {:group => @group}
  end

  def share
    if !@group.share_url
      @group.shortenUrl
    end
    render :partial => "share", :locals => {:group => @group}
  end

  def avatar
    render "shared/avatar", :locals => {
        :upload_url => "/groups/#{@group.id}/avatar_upload",
        :crop_url => "/groups/#{@group.id}/crop",
        :current_avatar_url => avatar_big(@group),
        :final_destination => "/groups/#{@group.id}",
        :noun => 'group'
      }
  end

  def avatar_upload
    @group.avatar = params[:file]
    @group.save
    render :json => {success: false}, :status => :ok
  end

  def crop
    render "shared/crop",
        :locals => {
          :resource => @group,
          :avatar_start_url => "/groups/#{@group.id}/avatar",
          :update_url => "/groups/#{@group.id}"
        }
  end

  def predictions
    @predictions = Prediction.recent.latest.for_group(@group.id)
    @predictions = @predictions.id_lt(param_id_lt)
    @predictions = @predictions.offset(param_offset).limit(param_limit)
    if param_offset.to_i > 0
      render :partial => "predictions/predictions"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :description, :avatar,:crop_x, :crop_y, :crop_w, :crop_h)
    end
end
