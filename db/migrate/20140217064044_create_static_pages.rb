class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :eng_title
      t.string :t_chines_title
      t.string :s_chines_title
      t.string :eng_content
      t.string :t_chines_content
      t.string :s_chines_content
      t.string :code
      t.boolean :state

      t.timestamps
    end
  end
end
