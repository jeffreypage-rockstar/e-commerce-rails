class Banner < ActiveRecord::Base
	
  	has_attached_file :image, PAPERCLIP_STORAGE_OPTS_BANNER ##  this constant is in /config/environments/*.rb
	
	
	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}

	
	scope :visible
	scope :active, :conditions => "#{Banner.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{Banner.table_name}.stae = #{INACTIVE}"

	def active?
	  state
	end
end
