class Admin::PushController < Admin::AdminController
  skip_before_filter :verify_authenticity_token

  def confirmpush
    if params[:userinput] != ''
      @user = User.where(["lower(username) = :username", {:username => params[:userinput].downcase }]).first
    elsif params[:contestinput] != ''
      @contest = Contest.where(:id => params[:contestinput]).first
      user_ids = []
      Contest.leaderboard(@contest).each do |l|
        user_ids << User.find(l[:user_id])
      end
      @ios_devices = AppleDeviceToken.where(:user_id => user_ids)
      @android_devices = AndroidDeviceToken.where(:user_id => user_ids)
    else
      @ios_devices = AppleDeviceToken.all
      @android_devices = AndroidDeviceToken.all
    end

  end

  def sendpush
    MarketingPush.perform_async(params)
  end


end
