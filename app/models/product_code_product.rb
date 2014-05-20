class ProductCodeProduct < ActiveRecord::Base
	belongs_to :product_code
	belongs_to :product
end
