class Commission < ActiveRecord::Base

	belongs_to :user

	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}

	validates_uniqueness_of :user_id, :message => "We can add only one commission for the user"
	
	scope :visible
	scope :active, :conditions => "#{Commission.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{Commission.table_name}.stae = #{INACTIVE}"

	def active?
	  state
	end
end
