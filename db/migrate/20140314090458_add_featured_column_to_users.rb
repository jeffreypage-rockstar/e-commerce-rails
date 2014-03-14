class AddFeaturedColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :featrued, :boolean
  end
end
