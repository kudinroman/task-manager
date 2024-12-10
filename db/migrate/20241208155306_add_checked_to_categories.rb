class AddCheckedToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :checked, :boolean
  end
end
