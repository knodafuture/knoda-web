class ContestStagesController < ApplicationController
  def new
    @contest_stage = ContestStage.new
    render layout: false
  end

  def create
    p = stage_params
    @contest_stage = ContestStage.create(p)
    redirect_to "/contests/#{p[:contest_id]}/edit"
  end

  private
    def stage_params
      params.permit(:name, :sort_order, :contest_id)
    end

end
