class AddDiscountToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :discount_percent, :integer
    add_column :variants, :commission, :float
    add_column :variants, :price_before_commission, :float
    add_column :variants, :price_after_discount, :float
    add_column :variants, :color, :string
  end
end
