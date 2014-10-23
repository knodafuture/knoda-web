class Admin::PushController < Admin::AdminController
  skip_before_filter :verify_authenticity_token

  def confirmpush
    if params[:userinput]
      @user = User.where(["lower(username) = :username", {:username => params[:userinput].downcase }]).first
    elsif params[:contestinput]

    elsif params[:pushtype]
      
    end

  end

  def sendpush
    MarketingPush.perform_async(params)
  end


end
