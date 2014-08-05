class Admin::UsersController < Admin::AdminController

  def search
    x = search_param
    name = x[:searchinput]
    name = name.downcase
    @u = User.where("username like ?", "%#{name}%")
    render "admin/home/index"
  end

  private

    def search_param
      params.permit(:searchinput)
    end

end
