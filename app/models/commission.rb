class Commission < ActiveRecord::Base

	belongs_to :user

	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}

	validates_uniqueness_of :user_id
	
	scope :visible
	scope :active, :conditions => "#{Commission.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{Commission.table_name}.stae = #{INACTIVE}"

	def active?
	  state
	end
end
