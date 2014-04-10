class ChangeRating < ActiveRecord::Migration
  def change
  	add_column :ratings, :designer_id, :integer
  end
end
