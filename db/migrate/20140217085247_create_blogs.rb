class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.text :video_url
      t.boolean :state
      t.integer :user_id

      t.timestamps
    end
  end
end
