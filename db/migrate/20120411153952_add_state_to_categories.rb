class AddStateToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :is_active, :boolean

  end
end
