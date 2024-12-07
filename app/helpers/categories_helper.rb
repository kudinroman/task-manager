module CategoriesHelper
  def category_link_path(category)
    if category.id.nil? && category.parent_id.present?
      subcategory_category_path(category.parent)
    elsif category.id.nil?
      categories_path(category)
    else
      category_path(category)
    end
  end
end
