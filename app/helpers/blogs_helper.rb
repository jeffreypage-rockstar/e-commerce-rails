module BlogsHelper
	def find_child(category)
		@sub_categories = BlogCategory.where('parent_id = ?',category.id)
		return @sub_categories
	end
end
