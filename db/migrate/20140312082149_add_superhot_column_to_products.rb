class AddSuperhotColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :super_hot, :boolean
  end
end
