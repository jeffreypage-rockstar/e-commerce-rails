class AddDescColumnToBanners < ActiveRecord::Migration
  def change
    add_column :banners, :link, :text
  end
end
