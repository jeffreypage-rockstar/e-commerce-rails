class NewsTranslation < ActiveRecord::Migration
  def up
	News.create_translation_table! :title => :string, :description => :text, :subject => :string
	 
  end

  def down
  	News.drop_translation_table!
  	
  end
end
