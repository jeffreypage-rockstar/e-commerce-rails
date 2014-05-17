class BlogsController < ApplicationController

	def index		
		@blog_categories = BlogCategory.active.where('parent_id is null')
		if params[:blog_category_id]
			@blogs = Blog.includes(:blog_categories).active.where(["blog_category_id = ?",params[:blog_category_id]]).paginate(:order => "created_at",:per_page=>pagination_rows,:page=>params[:page])
		else
			@blogs = Blog.includes(:blog_categories).active.paginate(:order => "created_at",:per_page=>2,:page=>params[:page])
		end
	end

	def show
		@blog_categories = BlogCategory.active.where('parent_id is null')
		@blog = Blog.active.find(params[:id])
		@comments = @blog.comments.paginate(:per_page=>10,:page=>params[:page])
		@comment = @blog.comments.new
		@news = News.where('state = ?',true)		
	end
end