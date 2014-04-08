module CroppableAvatar extend ActiveSupport::Concern
  included do
    has_attached_file :avatar, :styles => { :big => ["344х344"], :small => ["100x100"], :thumb => ["40x40"]}, :processors => [:cropper], :default_url => ""
    attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  end

  module ClassMethods
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    avatar_path = (avatar.options[:storage] == :s3) ? avatar.url(style) : avatar.path(style)
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar_path)
  end    

  def avatar_from_path(path)
    self.avatar = File.open(path)
  end     

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def reprocess_avatar
    avatar.reprocess!
  end
  
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