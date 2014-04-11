class AddParentBlogCategory < ActiveRecord::Migration
  def change
  	add_column :blog_categories, :parent_id, :integer
  	add_index :blog_categories, :parent_id
  end
end
