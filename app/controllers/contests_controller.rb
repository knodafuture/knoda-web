class ContestsController < ApplicationController
  #before_filter :admin_required
  skip_before_action :authenticate_user!, only: [:embed]
  before_action :set_contest, only: [:embed, :edit, :new_stage, :embed_standings]

  def admin
    render "admin", layout: true
  end

  def edit
    @user = current_user
    #render "contests/edit"
  end

  def new
    @contest = Contest.new
    render layout: false
  end

  def create
      p = contest_params

      @contest = Contest.new
      @contest = current_user.contests.create(p)
      #current_user.memberships.where(:contest_id => @contest.id).first.update(role: 'OWNER')
      render "admin"
  end


  def embed
    @user = current_user
    response.headers["X-XSS-Protection"] = "0"
    render 'contests/embed', :layout => false
  end


  def add_prediction
    x = prediction_params
    @prediction = Prediction.new
    @prediction = Prediction.create(x)
    render"contests/home/index"
  end



  def avatar
    render "shared/avatar", :locals => {
        :upload_url => "/contests/#{@contest.id}/avatar_upload",
        :crop_url => "/contests/#{@contest.id}/crop",
        :current_avatar_url => avatar_big(@contest),
        :final_destination => "/groups/#{@contest.id}",
        :noun => 'group'
      }
  end

  def avatar_upload
    @contest.avatar = params[:file]
    @contest.save
    #render :json => {success: false}, :status => :ok
  end

  def crop
    render "shared/crop",
        :locals => {
          :resource => @contest,
          :avatar_start_url => "/contests/#{@contest.id}/avatar",
          :update_url => "/contests/#{@contests.id}"
        }
  end

  def embed_standings
    if params[:stage]
      @leaders = Contest.stage_leaderboard(ContestStage.find(params[:stage]))
    else
      @leaders = Contest.leaderboard(@contest)
    end
    render :partial => "embed_standings",
      :locals => {:leaders => @leaders}
  end

  protected
    def admin_required
      if not current_user.is_admin?
        redirect_to '/'
      end
    end

  private
    def set_contest
      @contest = Contest.find(params[:id])
    end

    def contest_params
      params.permit(:name, :description, :avatar, :detail_url, :rules_url, :crop_x, :crop_y, :crop_w, :crop_h)
    end

    def prediciton_params
      params.permit(:body, :user, :expires_at, :tags, :resolution_date, :contest_id)
    end

    def stage_params
      params.permit(:name, :sort_order)
    end
end
