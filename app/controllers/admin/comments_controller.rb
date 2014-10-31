class Admin::CommentsController < Admin::AdminController
  skip_before_filter :verify_authenticity_token


  def delete
    @comment = Comment.find(params[:id])
    @comment.destroy
    render nothing:true, status:200
  end

private
end
