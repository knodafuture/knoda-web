module ActivitiesHelper
  def activity_icon(activity)
	case (activity.activity_type)
      when 'LOST'
        activity.image_url
      when 'WON'
          activity.image_url
      when 'COMMENT'
        "icons/ActivityCommentIcon.png"
      when 'EXPIRED'
        "icons/ActivityExpiredIcon.png"
      when "INVITATION"
        "icons/activity/activity_groups_icon.png"
    end
  end

end
