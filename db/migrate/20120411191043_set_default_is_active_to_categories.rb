class SetDefaultIsActiveToCategories < ActiveRecord::Migration
  def up
    change_column_default(:categories, :is_active, true)
  end

  def down
    change_column_default(:categories, :is_active, nil)
  end
end
