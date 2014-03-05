class AddColumnToBanners < ActiveRecord::Migration
  def change
  	add_column :banners, :image_file_name, :string
    add_column :banners, :image_content_type, :string
    add_column :banners, :image_file_size, :integer
    add_column :banners, :image_updated_at, :datetime
  end
end
