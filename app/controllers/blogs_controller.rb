class BlogsController < ApplicationController

	def index
		@blogs = Blog.all.active
	end

	def show
		@blog = Blog.active.find(params[:id])
		@comments = @blog.comments.paginate(:per_page=>10,:page=>params[:page])
		@comment = @blog.comments.new
	end


end
