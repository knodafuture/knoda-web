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
    end  	
  end

end
