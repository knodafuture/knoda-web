class Prediction < ActiveRecord::Base
  belongs_to :user
  has_many :challenges, :dependent => :destroy
  has_many :voters, through: :challenges, class_name: "User", source: 'user'
  has_many :comments, :dependent => :destroy

  def disagreed_count
    self.challenges.find_all_by_agree(false).count
  end

  def agreed_count
    self.challenges.find_all_by_agree(true).count
  end

  def agreePercent
    ((self.challenges.find_all_by_agree(true).count / self.challenges.count) * 100).round
  end
end
