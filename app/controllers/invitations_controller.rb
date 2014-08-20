class InvitationsController < AuthenticatedController
  before_filter :authenticate_user!

  def create
    if params[:group_id]
      @invitation = current_user.invitations.create(invitation_params)
      respond_with(@invitation, :serializer => InvitationSerializer, :status => 401)
    else
      @invitations = []
      params[:_json].each do | invitation_list_params |
        invitation_list_params.permit!
        invitation = current_user.invitations.create(invitation_list_params)
        @invitations << invitation
      end
      render :json => @invitations
    end
  end


  def accept
    invitation = Invitation.where(:code => params[:invitation_code]).first
    puts invitation.id
    if invitation
      begin
        invitation.user.followings.create!(:leader_id => current_user.id)
      rescue ActiveRecord::RecordNotUnique => e
      end
    end
    redirect_to '/'
  end
  private
    def invitation_params
      params.permit([:_json, :group_id, :recipient_email, :recipient_user_id])
    end
end
