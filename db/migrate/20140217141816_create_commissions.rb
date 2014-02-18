class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.integer :user_id
      t.float :commission
      t.boolean :state
      t.timestamps
    end
  end
end
