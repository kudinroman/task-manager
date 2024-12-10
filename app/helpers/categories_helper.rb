module CategoriesHelper
  def category_link_path(category)
    if category.id.nil?
      categories_path(category)
    else
      category_path(category)
    end
  end
end
