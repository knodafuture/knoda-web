module GroupsHelper
  def user_rank(user, leaderboard)
    match = leaderboard.index{|li|li[:user_id]==user.id}
    return leaderboard[match][:rankText]
  end

  def winning_percentage(won, lost)
    if won > 0
      (won.to_f / (won + lost) * 100.0).round(2)
    else
      0.00
    end
  end  

  def leader_username(group)
    l = Group.weeklyLeaderboard(group)[0]
    return l[:username]
  end

  def my_rank(group)
    me = Group.weeklyLeaderboard(group).select { |u| u[:user_id] == current_user.id}
    return me[0][:rank]
  end  

  def group_size(group)
    return group.users.size
  end
end