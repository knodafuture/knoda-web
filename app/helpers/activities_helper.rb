module ActivitiesHelper
  def activity_icon(activity)
	case (activity.activity_type)
      when 'LOST'
        "icons/ActivityLostIcon@2x.png"
      when 'WON'
        "icons/ActivityWonIcon@2x.png"
      when 'COMMENT'
        "icons/ActivityCommentIcon@2x.png"
      when 'EXPIRED'
        "icons/ActivityExpiredIcon@2x.png"
    end  	
  end

end
