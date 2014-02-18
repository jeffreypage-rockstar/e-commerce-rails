class CommentsController < ApplicationController

	def create
		# render :text => params.inspect and return false
		@blog= Blog.find(params[:blog_id])
		@comment = @blog.comments.new(permited_params)
		if @comment.save
			redirect_to :back
		end
	end
	

	private

  	def permited_params
    	params.require(:comment).permit!#(:title, :description, :state,:video_url,:user_id)
  	end
end
