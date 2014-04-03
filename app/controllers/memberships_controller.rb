class MembershipsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_membership, only: [:destroy]
  after_action :rebuild_leaderboard, only: [:destroy, :create]

  def create
    p = membership_params
    if p[:code]
      code = p[:code]
      invitation = Invitation.where(:code => code, :group_id => p[:group_id].to_i).first
      if invitation != nil and not invitation.accepted
        p.delete :code
        @membership = current_user.memberships.create(p)
        invitation.update(:accepted => true)
        render :json => @membership
        Activity.where(:invitation_code => code, :activity_type => 'INVITATION').delete_all
      else
        head :forbidden
      end
    else  
      group = Group.find(p[:group_id].to_i)
      if group.share_url
          @membership = current_user.memberships.create(p)
          render :json => @membership
      else
        head :forbidden
      end
    end
  end

  def destroy
    authorize_action_for(@membership)
    @membership.destroy
    head :no_content
    Group.rebuildLeaderboards(@membership.group)
  end  

  private
    def membership_params
      params.require(:membership).permit(:group_id, :code)
    end    
    def set_membership
      @membership = Membership.find(params[:id])
    end    
    def rebuild_leaderboard
      Group.rebuildLeaderboards(@membership.group)
    end
end  