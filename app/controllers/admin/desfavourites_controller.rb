require 'will_paginate/array'
class Admin::DesfavouritesController < Admin::BaseController
	#helper_method :sort_column, :sort_direction, :product_types
	def show
		@product_rocks = []
		@product = Product.find(params[:id])
		@product.product_rocks.each do |product_rock|
			@product_rocks << product_rock
		end
		@product_rocks = @product_rocks.paginate(:page => pagination_page, :per_page => 10)
	end

end