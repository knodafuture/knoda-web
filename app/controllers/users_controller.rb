class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def account
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    puts user_params
    if @user.update_attributes!(user_params)
      sign_in @user, :bypass => true
      render :json => {:success =>true}
    else
      render :json => {:success =>false}
    end
  end

  private
    def user_params
      params.required(:user).permit(:password, :password_confirmation)
    end  
end