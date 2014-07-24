class Admin::HomeController < Admin::AdminController
  def index
    render "index", layout: false
  end

end
