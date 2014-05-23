class AddStatusToBlogCategories < ActiveRecord::Migration
  def change
    add_column :blog_categories, :status, :integer
  end
end
