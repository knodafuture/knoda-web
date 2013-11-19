class User < ActiveRecord::Base
  has_many :predictions, :dependent => :destroy
  has_attached_file :avatar, :styles => { :big => "344х344>", :small => "100x100>", :thumb => "40x40>" }
end

