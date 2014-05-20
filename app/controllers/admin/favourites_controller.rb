require 'will_paginate/array'
class Admin::FavouritesController < Admin::BaseController
	def index
	
		#@favourites = ProductRock.paginate(:page => pagination_page, :per_page => 10)
	
	end

	def show
		@user = User.find(params[:id])
		#@ratings = []
		@favourites = []
		#@ratings = Rating.where('designer_id = ?',@designer.id).to_a.map(&:serializable_hash)
		#@ratings = @ratings.paginate(:page => pagination_page, :per_page => 10)
		if(@user.designer?)
			@products = @user.products
		elsif(@user.admin? || @user.superadmin?)
			@products = Product.all
		end
		#@products.each do |product|
		#	product.product_rocks.each do |favourite|
		#		@favourites << favourite
		#	end
		#end
		#@favourites = @favourites.paginate(:page => pagination_page, :per_page => 10)
		@products = @products.paginate(:page => pagination_page, :per_page => 10)
	end

end