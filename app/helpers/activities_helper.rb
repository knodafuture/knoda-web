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
  def activity_title(activity)
    if activity.activity_type == 'WON'
      title = activity.title
      title.gsub!("You Won", "<span class='won-text'>You Won</span>")
      return "#{title}"
    elsif activity.activity_type == 'LOST'
      title = activity.title
      title.gsub!("You Lost", "<span class='lost-text'>You Lost</span>")
      return "#{title}"
    else
      return activity.title
    end
  end
end
