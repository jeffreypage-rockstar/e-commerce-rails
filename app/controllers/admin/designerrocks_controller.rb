#require 'will_paginate/array'
class Admin::DesignerrocksController < Admin::BaseController
	#helper_method :sort_column, :sort_direction, :product_types
	def show
		@designer = User.find(params[:id])
		#@ratings = []
		#@ratings = Rating.where('designer_id = ?',@designer.id).to_a.map(&:serializable_hash)
		#@ratings = @ratings.paginate(:page => pagination_page, :per_page => 10)
		@ratings = Rating.paginate(:page => pagination_page, :per_page => 10)
		#@ratings = Rating.where('designer_id = ?',@designer.id)
		# render :text => @ratings.inspect and return false
	end

end