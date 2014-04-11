class News < ActiveRecord::Base
  	translates :title, :description, :subject
  	#validate, :on => [ :create, :update ]
	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}
	
	
	
	scope :active, :conditions => "#{News.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{News.table_name}.stae = #{INACTIVE}"


	def active?
	  state
	end
    def validate
    	if News.active.count < 4
    		true
    	else
    		errors.add(:base, "Active news should be 4 or less than 4")
    		#errors[:base] << 'Active news should be 4 or less than 4'
    		false
    	end
    end

end
