class StaticPage < ActiveRecord::Base
	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}
	
	# validates_presence_of :eng_title  
	# validates_uniqueness_of :eng_title
	
	scope :visible
	scope :active, :conditions => "#{StaticPage.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{StaticPage.table_name}.stae = #{INACTIVE}"

	def active?
	  state
	end
end
