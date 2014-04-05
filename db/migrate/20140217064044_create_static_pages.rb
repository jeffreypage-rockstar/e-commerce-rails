class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :title      
      t.string :content      
      t.string :code
      t.boolean :state

      t.timestamps
    end
  end
end
