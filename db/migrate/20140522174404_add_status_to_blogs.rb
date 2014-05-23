class AddStatusToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :status, :integer
  end
end
