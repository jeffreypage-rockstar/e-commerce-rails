class ChageProductCodeVariant < ActiveRecord::Migration
  def change
  	rename_column :product_code_products, :product_id, :variant_id
  end
end
