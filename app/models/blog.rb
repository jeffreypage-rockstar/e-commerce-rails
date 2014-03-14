class Blog < ActiveRecord::Base
	# => Relations 
	has_many   :comments, as: :commentable
	has_attached_file :image, PAPERCLIP_STORAGE_OPTS_BANNER ##  this constant is in /config/environments/*.rb
	belongs_to :blog_category
	belongs_to :user
    
	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}
	
	# validates_presence_of :eng_title  
	# validates_uniqueness_of :eng_title
	
	scope :visible
	scope :active, :conditions => "#{Blog.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{Blog.table_name}.stae = #{INACTIVE}"


	def active?
	  state
	end

end
