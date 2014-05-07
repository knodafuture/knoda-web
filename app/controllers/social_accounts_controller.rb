class SocialAccountsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:destroy]
  before_action :set_social_account, only: [:destroy]

  def destroy
    @social_account.destroy
    respond_to do |format|
      format.html { redirect_to '/users/me' }
      format.json { head :no_content }
    end
  end

  private
    def set_social_account
      @social_account = SocialAccount.find(params[:id])
    end
end
