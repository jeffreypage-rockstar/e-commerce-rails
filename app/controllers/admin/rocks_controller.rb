require 'will_paginate/array'
class Admin::RocksController < Admin::BaseController
	def index
		@designers = []
		@users = User.all
		@users.each do |user|
			if user.designer?
				@designers << user
			end
		end
		 @designers = @designers.paginate(:page => pagination_page, :per_page => 10)
	end

end