class Admin::HomeController < Admin::AdminController
  def index
    render "index", layout: true
  end

end
