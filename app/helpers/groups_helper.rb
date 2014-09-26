module GroupsHelper

  def winning_percentage(won, lost)
    if won > 0
      return "#{(won.to_f / (won + lost) * 100.0).round(2)}%"
    else
      if lost > 0
        return "0%"
      else
        return "-"
      end
    end
  end

  def leader_username(group)
    l = Group.weeklyLeaderboard(group)[0]
    return l[:username]
  end

  def my_rank(group)
    me = Group.weeklyLeaderboard(group).select { |u| u[:user_id] == current_user.id}
    if me and me[0]
      return me[0][:rank]
    else
      return '?'
    end
  end

  def group_size(group)
    return group.users.size
  end

  def my_membership(group)
    return current_user.memberships.where(:group => group).first
  end
end
