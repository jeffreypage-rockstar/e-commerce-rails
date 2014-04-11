class AddPlaceCokumnToBanner < ActiveRecord::Migration
  def change
    add_column :banners, :place, :string
  end
end
