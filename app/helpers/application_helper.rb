module ApplicationHelper
  def resource_name
    :user
  end
   
  def resource
    @resource ||= User.new
  end
   
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
   
  def resource_class 
    User 
  end

  def avatar_small(user)
    if user.avatar_image
      return user.avatar_image[:small]
    else
      return 'http://placehold.it/100x100'
    end
  end

  def avatar_big(user)
    if user.avatar_image
      return user.avatar_image[:big]
    else
      return 'http://placehold.it/344x344'
    end
  end  

end
