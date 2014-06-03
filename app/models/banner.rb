class Banner < ActiveRecord::Base
	
	translates :title,:description
  	has_attached_file :image, PAPERCLIP_STORAGE_OPTS_BANNER ##  this constant is in /config/environments/*.rb
	
	# validate :size_by_type
	validate :file_dimensions, :unless => "errors.any?"


	def size_by_type
		# if place == 
		# end
		
	end

	ACTIVE    = 1
	INACTIVE  = 0

	STATES = {    
	  1 => 'Active',
	  0 => 'Inactive'
	}
	PLACES = {    
	  "main_slide" => 'Main Page Slider',
	  "main_small" => 'Main Page After Slider',
	  "sale_slide" => 'Sale Page slider',
	  "sale_small" => 'Sale Page after Slider',
	  "hot_slide" => 'Hot Page slider'
	}
	
	scope :visible
	scope :active, :conditions => "#{Banner.table_name}.state = #{ACTIVE}"
	scope :inactive, :conditions => "#{Banner.table_name}.state = #{INACTIVE}"

	def active?
	  state
	end

	def file_dimensions
		 unless image.queued_for_write.blank?
		  dimensions = Paperclip::Geometry.from_file(image.queued_for_write[:original].path)
		  # self.width = dimensions.width
		  # self.height = dimensions.height
		  if place == 'main_slide' && dimensions.width != 1950 && dimensions.height != 550
		  	# errors.add(:image,'width or height is not matching. Please upload image with size 1950 X 550 pixel for Main Page Slider')
		  elsif place == 'main_small' && dimensions.width != 370 && dimensions.height != 200
				errors.add(:image,'width or height is not matching. Please upload image with size 370 X 200 pixel for Main Page Image After Slider')
			elsif place == 'sale_slide' && dimensions.width != 1950 && dimensions.height != 550
				errors.add(:image,'width or height is not matching. Please upload image with size 1950 X 550 pixel for Sale Page Slider')
			elsif place == 'sale_small' && dimensions.width != 370 && dimensions.height != 200
		  	errors.add(:image,'width or height is not matching. Please upload image with size 370 X 200 pixel for Sale Page Image After Slider')
		  	elsif place == 'hot_slide' && dimensions.width != 1950 && dimensions.height != 550
				errors.add(:image,'width or height is not matching. Please upload image with size 1950 X 550 pixel for Hot Page Slider')
		  end
		end
	end

end
