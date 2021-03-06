module AuthenticationConcern extend ActiveSupport::Concern
  included do
  	before_filter :unseen_activities
	skip_before_filter :verify_authenticity_token
  end

  module ClassMethods
  end         


  def unseen_activities
    current_user.predictions.readyForResolution.notAlerted.each do |p|
      p.update(activity_sent_at: DateTime.now)
      current_user.activities.create!(user: current_user, prediction_id: p.id, title: "Your prediction has expired. Please settle the outcome", prediction_body: p.body, activity_type: "EXPIRED");
    end  	
  	s = current_user.activities.unseen.size
  	if s > 0
  		@unseen_activities = s
  	end
  end
end  
