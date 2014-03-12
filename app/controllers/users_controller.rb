class UsersController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :avatar, :crop, :default_avatar, :avatar_upload]
  skip_before_action :verify_authenticity_token, only: [:avatar_upload]

  # GET /users
  # GET /users.json
  def index
    if params[:agrees_with]
      @users = User.joins(:challenges).where(challenges: { prediction_id: params[:agrees_with], agree: true})
    elsif params[:disagrees_with]
      @users = User.joins(:challenges).where(challenges: { prediction_id: params[:disagrees_with], agree: false})
    else
      @users = User.all
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if @user != current_user
      render 'show_public'
    else
      render 'show'
    end
  end

  def avatar
    @avatar_version = 1 + rand(5)
  end

  def avatar_upload
    @user.avatar = params[:file]
    @user.save
    render :json => {success: false}, :status => :ok
  end

  def default_avatar
    av = params[:avatar_version] || (1 + rand(5))
    p = Rails.root.join('app', 'assets', 'images', 'avatars', "avatar_#{av}@2x.png")
    @user.avatar_from_path p
    @user.save
    redirect_to '/predictions'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in :user, @user
      if params[:user][:avatar].blank?
        return render :json => {:success => true, :location => '/users/me/avatar?new_user=true'}
      else
        return render :json => {:success => true, :location => '/users/me/crop?new_user=true'} 
      end
    else
      return render :json => {:success => false, :errors => @user.errors}, :status => 400
    end
  end

  def crop
  end

  def update
    if @user.update_attributes(user_params)
      if params[:user][:avatar].blank?
        if @user.cropping?
          @user.reprocess_avatar
          redirect_to '/'
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
    render json: User.search(params[:query], fields: [{:username => :text_start}], limit: 10)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if params[:id] == 'me'
        @user = current_user
      else
        @user = User.where(["lower(username) = :username", {:username => params[:id].downcase }]).first
      end
      if not @user
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.required(:user).permit(:email, :username, :password, :password_confirmation, :avatar,:crop_x, :crop_y, :crop_w, :crop_h)
    end
end
