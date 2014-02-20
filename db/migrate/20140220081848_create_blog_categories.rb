class CreateBlogCategories < ActiveRecord::Migration
  def change
    create_table :blog_categories do |t|
      t.string :name
      t.boolean :state
      t.timestamps
    end
	add_column :blogs, :blog_category_id, :integer
  end
end
