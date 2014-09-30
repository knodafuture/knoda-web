class UsersController < AuthenticatedController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :unseen_activities, only: [:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :avatar, :crop, :avatar_upload, :settings, :history, :social, :rivals]
  skip_before_action :verify_authenticity_token, only: [:avatar_upload]

  # GET /users/1
  # GET /users/1.json
  def show
    if params[:history] == 'votes'
      @predictions = []
      predictionIds = []
      challenges = current_user.challenges.picks
      if param_id_lt
        challenges = challenges.where('challenges.id < ?', param_id_lt)
      end
      challenges = challenges.offset(param_offset).limit(param_limit)
      challenges.each do |c|
        predictionIds << c.prediction_id
      end
      challengeHash = Hash[predictionIds.map.with_index.to_a]
      @predictions = Prediction.includes(:challenges, :comments).where(:id => predictionIds).to_a.sort!{|p1,p2| challengeHash[p1.id] <=> challengeHash[p2.id] }
    else
      @predictions = @user.predictions.visible_to_user(current_user).order('created_at desc').offset(param_offset).limit(param_limit).id_lt(param_id_lt)
    end
    render 'show'
  end

  def settings
    if @user != current_user
      render 'show'
    else
      render 'settings'
    end
  end

  def avatar
  render "shared/avatar",
      :locals => {
        :upload_url => "/users/me/avatar_upload",
        :crop_url => "/users/me/crop?destination=#{params[:destination]}",
        :current_avatar_url => avatar_big(@user),
        :final_destination => params[:destination] || '/',
        :noun => 'profile'
      }
  end

  def avatar_upload
    @user.avatar = params[:file]
    @user.save
    render :json => {success: false}, :status => :ok
  end

  def create
    @user = User.new(user_params)
    if @user.avatar.blank?
      av = (1 + rand(5))
      p = Rails.root.join('app', 'assets', 'images', 'avatars', "avatar_#{av}@2x.png")
      @user.avatar_from_path p
      @user.save
    end
    if @user.save
      UserEvent.new(:user_id => @user.id, :name => 'SIGNUP', :platform => extra_create_params['signup_source']).save
      sign_in :user, @user
      if params[:user][:avatar].blank?
        return render :json => {:success => true, :location => '/users/me/avatar?new_user=true', :user => @user}
      else
        return render :json => {:success => true, :location => '/users/me/crop?new_user=true', :user => @user}
      end
    else
      return render :json => {:success => false, :errors => @user.errors}, :status => 400
    end
  end

  def crop
    render "shared/crop",
        :locals => {
          :resource => @user,
          :avatar_start_url => "/users/me/avatar?destination=#{params[:destination]}",
          :update_url => "/users/me?destination=#{params[:destination]}"
        }
  end

  def update
    if @user.update_attributes(user_params)
      if params[:user][:avatar].blank?
        if @user.cropping?
          @user.reprocess_avatar
          redirect_to params[:destination] || '/'
        else
          respond_to do |format|
            format.json { render json: @user, :status => 200 }
            format.html { redirect_to @user }
          end
        end
      else
        render :action => "crop"
      end
    else
      respond_to do |format|
        format.json { render json: @user.errors, :status => 400 }
        format.html { render :action => 'edit'}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      sign_in @user, :bypass => true
      render status: 200, json: {}
    else
      render :json => @user.errors, :status => :bad_request
    end
  end

  def autocomplete
    @searchResults = User.search(params[:q], fields: [{:username => :text_start}], limit: 10, order: {_score: :desc, points: :desc})
    @users = []
    @searchResults.each do |x|
      if current_user.id != x.id
        @users << x
      end
    end
    if params[:nameOnly]
      render :json => @users.collect { |u| u.username }, :root => false
      return
    end
  end

  def history
    if params[:history] == 'votes'
      @predictions = []
      predictionIds = []
      challenges = current_user.challenges.picks
      if param_id_lt
        challenges = challenges.where('challenges.id < ?', param_id_lt)
      end
      challenges = challenges.offset(param_offset).limit(param_limit)
      challenges.each do |c|
        predictionIds << c.prediction_id
      end
      challengeHash = Hash[predictionIds.map.with_index.to_a]
      @predictions = Prediction.includes(:challenges, :comments).where(:id => predictionIds).to_a.sort!{|p1,p2| challengeHash[p1.id] <=> challengeHash[p2.id] }
    else
      @predictions = @user.predictions.order('created_at desc').offset(param_offset).limit(param_limit).id_lt(param_id_lt)
    end
    render :partial => "predictions/predictions"
  end

  def social
    render partial: 'social'
  end

  def contest_agreement
    current_user.user_agreements.create(:agreement_type => 'CONTEST_ADMIN')
    head :no_content
  end

  def rivals
  end

  private
    def set_user
      if numeric?(params[:id])
        @user = User.find(params[:id])
        if not @user
          @user = User.where(["lower(username) = :username", {:username => params[:id].downcase }]).first
        end
      else
        if params[:id] == 'me'
          @user = current_user
        else
          @user = User.where(["lower(username) = :username", {:username => params[:id].downcase }]).first
        end
      end

      if not @user
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    def user_params
      params.required(:user).permit(:email, :username, :password, :password_confirmation, :avatar,:crop_x, :crop_y, :crop_w, :crop_h, :phone)
    end

    def extra_create_params
      params.permit(:signup_source)
    end

    def numeric?(object)
      true if Float(object) rescue false
    end
end
