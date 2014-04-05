class CreateTranslationGlobalizationTables < ActiveRecord::Migration
	
	def up
	 	Brand.create_translation_table! :name => :string
	 	Product.create_translation_table! :name => :string ,:description_markup=>:text, :description => :text, :meta_keywords =>:text ,:meta_description	=> :text,:product_keywords =>:text
	 	Variant.create_translation_table! :name =>:string
	 	ProductType.create_translation_table! :name =>:string
	 	Property.create_translation_table! :display_name =>:string
	 	Prototype.create_translation_table! :name =>:string
		Banner.create_translation_table! :title=>:string ,:description=>:text
		User.create_translation_table! :first_name =>:string ,:last_name=>:string,:title=>:string,:about_me=> :text
		BlogCategory.create_translation_table! :name =>:string
		Blog.create_translation_table! :title =>:string, :description=>:text
		StaticPage0.create_translation_table! :title=>:string ,:content=>:text
  end

  def down
  	Brand.drop_translation_table!
  	Product.drop_translation_table!
  	Variant.drop_translation_table!
  	ProductType.drop_translation_table!
  	Property.drop_translation_table!
  	Prototype.drop_translation_table!
  	Banner.drop_translation_table!
  	BlogCategory.drop_translation_table!
  	Blog.drop_translation_table!
  	StaticPage.drop_translation_table!
  end

end
