class Admin::UsersController < Admin::AdminController
  skip_before_filter :verify_authenticity_token
  def search
    x = search_param
    name = x[:searchinput]
    name = name.downcase
    @u = User.where("username like ?", "%#{name}%")
    render "admin/home/index"
  end

  def update
    x= user_params
    @u = User.find(x[:id])
    if x.has_key?(:verified_account)
      @u.verified_account=x[:verified_account]
      @u.save
    end
    if x.has_key?(:admin)
      if @u.is_admin?
        if x[:admin] == "false"
          @u.roles_will_change!
          @u.roles.delete("ADMIN")
          @u.save
        end
      else
        if x[:admin] == "true"
          if !@u.roles
            @u.roles=[]
          end
          @u.roles_will_change!
          @u.roles << "ADMIN"
          @u.save
        end
      end
    end
    render nothing:true,status:200
  end

  private

  def search_param
    params.permit(:searchinput)
  end

  def user_params
    params.permit(:id, :verified_account, :admin)
  end

end
