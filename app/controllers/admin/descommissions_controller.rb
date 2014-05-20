require 'will_paginate/array'
class Admin::DescommissionsController < Admin::BaseController
	#helper_method :sort_column, :sort_direction, :product_types
	def show
		@designer = User.find(params[:id])
		#@ratings = []
		@variants = []
		#@ratings = Rating.where('designer_id = ?',@designer.id).to_a.map(&:serializable_hash)
		#@ratings = @ratings.paginate(:page => pagination_page, :per_page => 10)

		@products = @designer.products
		@products.each do |product|
			product.variants.each do |variant|
				@variants << variant
			end
		end
		@variants = @variants.paginate(:page => pagination_page, :per_page => 10)
		#.to_a.map(&:serializable_hash)
		#@ratings = ratings
		#@ratings = Rating.where('designer_id = ?',@designer.id)
		# render :text => @ratings.inspect and return false
	end

end