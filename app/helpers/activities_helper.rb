module ActivitiesHelper
  def activity_icon(activity)
	case (activity.activity_type)
      when 'LOST'
        "icons/ActivityLostIcon.png"
      when 'WON'
        "icons/ActivityWonIcon.png"
      when 'COMMENT'
        "icons/ActivityCommentIcon.png"
      when 'EXPIRED'
        "icons/ActivityExpiredIcon.png"
      when "INVITATION"
        "icons/activity/activity_groups_icon.png"
    end  	
  end

end
