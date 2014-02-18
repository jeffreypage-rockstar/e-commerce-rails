class Blog < ActiveRecord::Base
	# => Relations 
	has_many   :comments, as: :commentable
	
	has_many :images, -> {order(:position)},
                    as:        :imageable,
                    dependent: :destroy

    accepts_nested_attributes_for :images,             reject_if: proc { |t| (t['photo'].nil? && t['photo_from_link'].blank?) }, allow_destroy: true

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
