class Admin::CommentsController < Admin::BaseController

  def destroy
  	@comment = Comment.find(params[:id])
  	@blog = @comment.commentable
  	@comment.destroy
  	redirect_to edit_admin_blog_path(@blog)
  end

end