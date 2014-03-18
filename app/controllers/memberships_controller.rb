class MembershipsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_membership, only: [:destroy]

  def create
    p = membership_params
    if p[:code]
      invitation = Invitation.where(:code => p[:code]).first
      if invitation != nil and invitation.group_id == p[:group_id].to_i
        p.delete :code
        membership = current_user.memberships.create(p)
        invitation.update(:accepted => true)
        render :json => membership
      else
        head :forbidden
      end
    else  
      group = Group.find(p[:group_id].to_i)
      if group.share_url
          membership = current_user.memberships.create(p)
          render :json => membership
      else
        head :forbidden
      end
    end
  end

  def destroy
    authorize_action_for(@membership)
    @membership.destroy
    head :no_content
  end  

  private
    def membership_params
      params.require(:membership).permit(:group_id, :code)
    end    
    def set_membership
      @membership = Membership.find(params[:id])
    end    
end  