class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.string :title
      t.string :subject
      t.string :hreflink
      t.text :description
      t.boolean :state, :default => true
      t.timestamps
    end
  end
  def self.down
    drop_table :news
  end
end
