class CommentsController < ApplicationController
  before_filter :authenticate_user!

  # POST /comments
  # POST /comments.json
  def create
    @comment = current_user.comments.create(comment_params)
    respond_to do |format|
      if @comment.save
        format.html {
          @prediction = Prediction.find(@comment.prediction_id)
          render :partial => 'predictions/comments', :locals => {:comments => @prediction.comments}
        }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def comment_params
      params.permit(:prediction_id, :text)
    end
end
