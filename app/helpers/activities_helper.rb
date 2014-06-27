module ActivitiesHelper
  def activity_icon(activity)
	case (activity.activity_type)
      when 'LOST'
        avatar_small(activity.user)
      when 'WON'
        avatar_small(activity.user)
      when 'COMMENT'
        "icons/ActivityCommentIcon.png"
      when 'EXPIRED'
        "icons/ActivityExpiredIcon.png"
      when "INVITATION"
        "icons/activity/activity_groups_icon.png"
    end
  end

end
