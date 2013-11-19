class Prediction < ActiveRecord::Base
  belongs_to :user
  has_many :challenges, :dependent => :destroy
  has_many :voters, through: :challenges, class_name: "User", source: 'user'
  has_many :comments, :dependent => :destroy
end
