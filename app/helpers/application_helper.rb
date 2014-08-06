module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    User
  end

  def avatar_small(user)
    if user.avatar_image
      return user.avatar_image[:small]
    else
      return image_path('avatars/avatar_1@2x.png')
    end
  end

  def avatar_big(resource)
    if resource.avatar_image
      return resource.avatar_image[:big]
    else
      return 'avatars/avatar_1@2x.png'
    end
  end

  def title(page_title)
    content_for :title, "Knoda | #{page_title.to_s}"
  end

  def display_challenge_icon(prediction)
    if (current_user.id != prediction.user_id)
      c = my_challenge(prediction)
      if c
        if c.agree
          render :partial => "predictions/display_challenge", :locals => {:disagreeClass => '', :agreeClass => 'active', :canVote => !prediction.is_expired?}
        else
          render :partial => "predictions/display_challenge", :locals => {:disagreeClass => 'active', :agreeClass => '', :canVote => !prediction.is_expired?}
        end
      else
        if (!prediction.is_expired?)
          render :partial => "predictions/display_challenge", :locals => {:disagreeClass => '', :agreeClass => '', :canVote => true}
        end
      end
    end
  end

  def display_challenge_icon_for_comment(comment)
      c = Challenge.where(:prediction_id => comment.prediction_id, :user_id => comment.user_id).first
      if c
        if c.agree
          image_tag('icons/sd/agree_active.png')
        else
          image_tag('icons/sd/disagree_active.png')
        end
      end
  end

  def display_won_lost(prediction)
    c = my_challenge(prediction)
    if prediction.is_closed? and c
      if (c.agree and prediction.outcome == true) or (!c.agree and prediction.outcome == false)
        content_tag(:span, :class=>'pull-right won-lost-indicator won') do
          'W'
        end
      else
        content_tag(:span, :class=>'pull-right won-lost-indicator lost') do
          'L'
        end
      end
    end
  end

  def active_challenge(prediction, challengeType)
    c = my_challenge(prediction)
    if c
      if c.agree and challengeType == 'agree'
        return 'active'
      end
      if !c.agree and challengeType == 'disagree'
        return 'active'
      end
    end
  end

  def embed_active_challenge(prediction, challengeType)
    if current_user
      c = my_challenge(prediction)
      if c
        if c.agree and challengeType == 'agree'
          return 'active'
        end
        if !c.agree and challengeType == 'disagree'
          return 'active'
        end
      end
    end
  end

  def display_close_status(prediction)
    if prediction.expires_at > Time.now
      return "closes #{distance_of_time_in_words_to_now(prediction.expires_at)} from now"
    else
      return "closed #{distance_of_time_in_words_to_now(prediction.expires_at)} ago"
    end
  end


  def display_result_outcome_icon(prediction)
    c = my_challenge(prediction)
    if c
      if (c.agree and prediction.outcome == true) or (!c.agree and prediction.outcome == false)
        image_tag("icons/ResultsWinIcon@2x.png")
      else
        image_tag("icons/ResultsLoseIcon@2x.png")
      end
    end
  end

  def display_owner_result_outcome_icon(prediction)
    if (prediction.outcome == true)
      image_tag("icons/ResultsWinIcon@2x.png")
    else
      image_tag("icons/ResultsLoseIcon@2x.png")
    end
  end

  def display_result_outcome_text(prediction)
    c = my_challenge(prediction)
    if c
      if (c.agree and prediction.outcome == true) or (!c.agree and prediction.outcome == false)
        return "YOU WON!"
      else
        return "YOU LOST!"
      end
    end
  end

  def my_challenge(prediction)
      l = prediction.challenges.select { |c| c.user_id == current_user.id}
      if l.length > 0
        return l[0]
      else
        return nil
      end
  end

  def total_points(prediction)
    if my_challenge(prediction)
      my_challenge(prediction).total_points
    end
  end

  def local_stylesheet_path(source)
    p = stylesheet_path(source)
    tokens = p.split("/")
    t = tokens[tokens.length-1]
    return "/assets/#{t}"
  end

  def is_challenged_by_me(prediction)
    l = prediction.challenges.select { |c| c.user_id == current_user.id}
    if l.length > 0
      return true
    else
      return false
    end
  end

  def voting_ends_on(prediction)
    return "Voting closes Sunday at 11:59am"
  end

  def my_contest_rank(contest)
    me = Contest.leaderboard(contest).select { |u| u[:user_id] == current_user.id}
    if me.length > 0
      return me[0][:rank].to_i.ordinalize
    else
      return nil;
    end
  end
end
