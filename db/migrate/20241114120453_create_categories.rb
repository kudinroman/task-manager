class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :depth

      t.timestamps
    end
  end
end
