class BlogsController < ApplicationController

	def index
		
		@blog_categories = BlogCategory.active
		if params[:blog_category_id]
			@blogs = Blog.includes(:blog_categories).active.where(["blog_category_id = ?",params[:blog_category_id]])
		else
			@blogs = Blog.includes(:blog_categories).active
		end
	end

	def show
		@blog = Blog.active.find(params[:id])
		@comments = @blog.comments.paginate(:per_page=>10,:page=>params[:page])
		@comment = @blog.comments.new
	end


end
