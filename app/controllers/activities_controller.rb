class ActivitiesController < AuthenticatedController
	before_filter :authenticate_user!

  def index
    current_user.predictions.readyForResolution.notAlerted.each do |p|
      p.update(activity_sent_at: DateTime.now)
      current_user.activities.create!(user: current_user, prediction_id: p.id, title: "Your prediction has expired. Please settle the outcome", prediction_body: p.body, activity_type: "EXPIRED");
    end

    case (params[:list])
      when 'unseen'
        @activities = current_user.activities.unseen.order('created_at desc')
      else
        @activities = current_user.activities.order('created_at desc')
    end
    render 'index'
    current_user.activities.update_all(seen: true)
  end
end  