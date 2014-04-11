class BlogCategory < ActiveRecord::Base
    acts_as_nested_set
	translates :name
	# => Relations 
	has_many :blogs
	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}
	
 	validates_presence_of :name 
	validates_uniqueness_of :name
	
	scope :visible
	scope :active, :conditions => "#{BlogCategory.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{BlogCategory.table_name}.stae = #{INACTIVE}"


	def active?
	  state
	end

	def self.subcategories(id)
		return self.where("parent_id = #{id}")
	end
end
