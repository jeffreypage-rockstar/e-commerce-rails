
class Admin::AdcommissionsController < Admin::BaseController
	def index
	
		@variants = Variant.paginate(:page => pagination_page, :per_page => 10)
	
	end

end