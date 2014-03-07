class CreateSubOrders < ActiveRecord::Migration
  def change
    create_table :sub_orders do |t|
      t.string :order_id
      t.string :suborder_id
      t.string :number
      t.string :ip_address
      t.string :email
      t.string :state
      t.integer :customer_id
      t.integer :designer_id
      t.integer :ship_address_id
      t.integer :coupon_id
      t.integer :active
      t.integer :shipped
      t.integer :shipments_count
      t.datetime :calculated_at
      t.datetime :completed_at
      t.decimal :credited_amount

      t.timestamps
    end
  end
end
