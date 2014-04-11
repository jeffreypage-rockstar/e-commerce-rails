class AddNestedSetToBlogCategory < ActiveRecord::Migration
  def self.up
    add_column :blog_categories, :rgt, :integer
    add_column :blog_categories, :lft, :integer

    add_index :blog_categories, :lft
    add_index :blog_categories, :rgt

    BlogCategory.reset_column_information
    BlogCategory.rebuild!
  end

  def self.down
    remove_column :blog_categories, :rgt
    remove_column :blog_categories, :lft
  end
end
