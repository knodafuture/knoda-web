class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :avatar, :crop, :default_avatar]

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

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def avatar
    @avatar_version = 1 + rand(5)
  end

  def default_avatar
    av = params[:avatar_version] || (1 + rand(5))
    p = Rails.root.join('app', 'assets', 'images', 'avatars', "avatar_#{av}@2x.png")
    @user.avatar_from_path p
    @user.save
    redirect_to @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if params[:user][:avatar].blank?
        flash[:notice] = "Successfully created user."
        redirect_to @user
      else
        render :action => "crop"
      end
    else
      render :action => 'new'
    end
  end

  def crop
  end

  def update
    puts params
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      if params[:user][:avatar].blank?
        if @user.cropping?
          @user.reprocess_avatar
        end
        flash[:notice] = "Successfully updated user."
        redirect_to @user
      else
        render :action => "crop"
      end
    else
      render :action => 'edit'
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if params[:id] == 'me'
        @user = current_user
      else
        @user = User.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.required(:user).permit(:password, :password_confirmation, :avatar,:crop_x, :crop_y, :crop_w, :crop_h)
    end
end
