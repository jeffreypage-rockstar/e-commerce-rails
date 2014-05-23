class CreateProductCodes < ActiveRecord::Migration
  def change
    create_table :product_codes do |t|
      t.string :title
      t.float :discount
      t.timestamps
    end
    ProductCode.create_translation_table! :title =>:string
  end
end
