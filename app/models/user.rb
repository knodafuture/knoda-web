class User < ActiveRecord::Base
  has_many :predictions, :dependent => :destroy
  has_attached_file :avatar, :styles => { :big => "344х344>", :small => "100x100>" }

  def avatar_image
    if self.avatar.exists?
      {
        big: self.avatar(:big),
        small: self.avatar(:small),
        thumb: self.avatar(:thumb)
      }
    else
      nil
    end
  end
end

