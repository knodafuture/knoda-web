class Admin::PushController < Admin::AdminController
  skip_before_filter :verify_authenticity_token

  def confirmpush
    @user = User.where(["lower(username) = :username", {:username => params[:userinput].downcase }]).first
    

  end

  def sendpush
    MarketingPush.perform_async(params)
  end


end
