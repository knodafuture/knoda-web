module GroupsHelper
  def user_rank(user, leaderboard)
    match = leaderboard.index{|li|li[:user].id==user.id}
    return leaderboard[match][:rankText]
  end

  def winning_percentage(won, lost)
    if won > 0
      (won.to_f / (won + lost) * 100.0).round(2)
    else
      0.00
    end
  end  
end