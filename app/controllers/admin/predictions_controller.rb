class Admin::PredictionsController < Admin::AdminController
  skip_before_filter :verify_authenticity_token
  def search
    x = search_param
    @predictions = Prediction.where("body ilike ?", "%#{x[:searchinput]}%")
    render "admin/home/index"
  end

  def delete
    @prediction = Prediction.find(params[:id])
    @prediction.destroy
    render nothing:true, status:200
  end

  private

  def search_param
    params.permit(:searchinput)
  end

  def user_params
    params.permit(:id, :verified_account, :admin, :contest_editor)
  end

end
