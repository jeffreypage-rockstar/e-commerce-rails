class AddProfileColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :bday, :date
    add_column :users, :about_me, :text
  end
end
