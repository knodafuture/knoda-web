class Prediction < ActiveRecord::Base
  belongs_to :user
  has_many :challenges, :dependent => :destroy
  has_many :voters, through: :challenges, class_name: "User", source: 'user'
  has_many :comments, :dependent => :destroy
  attr_accessible :body, :expires_at, :resolution_date

  def disagreed_count
    d = self.challenges.select { |c| c.agree == false}
    d.length        
  end

  def agreed_count
    d = self.challenges.select { |c| c.agree == true}
    d.length    
  end

  def agreePercent
    ((self.agreed_count.to_f / self.challenges.count.to_f) * 100).floor
  end
end
