class AddUserIdColumnToProperties < ActiveRecord::Migration
  def change
  	add_column :properties, :user_id, :integer 
  	add_column :prototypes, :user_id, :integer 
  	add_column :image_groups, :user_id, :integer 
  	add_column :brands, :user_id, :integer 
  	add_column :products, :user_id, :integer 
  end

end
