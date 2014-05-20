class CreateProductCodeProducts < ActiveRecord::Migration
  def change
    create_table :product_code_products do |t|
      t.integer :product_code_id
      t.integer :product_id
      t.timestamps
    end
  end
end
