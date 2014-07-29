class Contests::HomeController < Contests::ContestsController
  def index
    render "index", layout: true
  end

end
