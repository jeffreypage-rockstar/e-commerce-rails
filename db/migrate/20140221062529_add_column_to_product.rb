class AddColumnToProduct < ActiveRecord::Migration
  def change
    add_column :products, :condition_of_product, :string 
    add_column :products, :gender, :string 
  end
end
