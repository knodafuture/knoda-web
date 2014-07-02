module ActivitiesHelper
  def activity_icon(activity)
	case (activity.activity_type)
      when 'EXPIRED'
        "icons/ActivityExpiredIcon@2x.png"
    end
  end
  def activity_title(activity)
    if activity.activity_type == 'WON'
      title = activity.title
      title.gsub!("-", "&#151;")
      title.gsub!("You Won", "<span class='won-text'>You Won</span>")
      return "#{title}"
    elsif activity.activity_type == 'LOST'
      title = activity.title
      title.gsub!("-", "&#151;")
      title.gsub!("You Lost", "<span class='lost-text'>You Lost</span>")
      return "#{title}"
    else
      return activity.title
    end
  end
end
