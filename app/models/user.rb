class User < ActiveRecord::Base
  has_many :predictions, :dependent => :destroy
  has_attached_file :avatar, :styles => { :big => "344х344>", :small => "100x100>" }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable,
         :authentication_keys => [:login]  

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

  attr_accessor :login
  attr_accessible :login, :email, :username, :password, :password_confirmation

  # Overrides the devise method find_for_authentication
  # Allow users to Sign In using their username or email address
  def self.find_for_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
  end
end

