class Scratch
  def self.rivals(user)
    user.challenges.pluck(:id)
  end

  def self.vs(current_user, target_user)
    currentUserWonIds = current_user.challenges.where(:is_right => true, :is_finished => true).pluck(:prediction_id)
    currentUserLostIds = current_user.challenges.where(:is_right => false, :is_finished => true).pluck(:prediction_id)
    targetUserWonIds = target_user.challenges.where(:is_right => true, :is_finished => true).pluck(:prediction_id)
    targetUserLostIds = target_user.challenges.where(:is_right => false, :is_finished => true).pluck(:prediction_id)

    currentUserWinRecord = currentUserWonIds & targetUserLostIds
    targetUserWinRecord = targetUserWonIds & currentUserLostIds
    puts "Current User won/lost"
    puts currentUserWonIds
    puts "-----"
    puts currentUserLostIds
    puts "Target User won/lost"
    puts targetUserWonIds
    puts "-----"
    puts targetUserLostIds
    puts "H2H record"
    puts "CurrentUser: #{currentUserWinRecord.size}"
    puts "TargetUser:  #{targetUserWinRecord.size}"

  end
end
