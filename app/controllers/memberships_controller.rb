class MembershipsController < ApplicationController
  before_filter :authenticate_user!

  def create
    p = membership_params
    if p[:code]
      invitation = Invitation.where(:code => p[:code]).first
      if invitation != nil and invitation.group_id == p[:group_id].to_i
        p.delete :code
        @membership = current_user.memberships.create(p)
        invitation.update(:accepted => true)
        render :json => @membership
      else
        head :forbidden
      end
    else
      head :forbidden
    end
  end

  private
    def membership_params
      params.require(:membership).permit(:group_id, :code)
    end    
end  