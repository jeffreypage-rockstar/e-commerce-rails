class RelatedProduct < ActiveRecord::Base

	belongs_to :product ,:foreign_key => :related_product_id

	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}

	
	
	scope :visible
	scope :active, :conditions => "#{Commission.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{Commission.table_name}.stae = #{INACTIVE}"

	def active?
	  state
	end
end
