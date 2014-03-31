class AddMainMenuForCategory < ActiveRecord::Migration
  def change
  	add_column :product_types, :main_menu, :boolean
  end
end
