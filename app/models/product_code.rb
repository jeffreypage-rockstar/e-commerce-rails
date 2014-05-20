class ProductCode < ActiveRecord::Base
  translates :title
  #before_save :validates_product_code
  has_many :product_code_products
  
  validates :title,    presence: true, length: { :maximum => 255 }

  # paginated results from the admin ProductType grid
  #
  # @param [Optional params]
  # @return [ Array[ProductType] ]
  def self.admin_grid(params = {})
    grid = ProductCode
    grid = ProductCode.where("product_codes.title LIKE ?", "#{params[:title]}%") if params[:title].present?
    grid
  end
  def self.validates_product_code(pr1,pr2,pr3,pr4)
  	count = 0
  	if pr1 != ""
  		count = count+1
  	end
  	if pr2 != ""
  		count = count+1
  	end
  	if pr3 != ""
  		count = count+1
  	end
  	if pr4 != ""
  		count = count+1
  	end
  	if count>=2
  		true
  	else
  		false
  	end
  end
end
