class CommentsController < ApplicationController

	def create
		# render :text => params.inspect and return false
		@blog= Blog.find(params[:blog_id])
		@comment = @blog.comments.new(permited_params)
		if @comment.save
			redirect_to :back
		else
			# render :json => @comment.errors.full_messages and return false
			flash[:notice] = @comment.errors.full_messages.collect{|x| x}.join('<br/>').html_safe
			redirect_to :back
		end

	end
	

	private

  	def permited_params
    	params.require(:comment).permit!#(:title, :description, :state,:video_url,:user_id)
  	end
end
