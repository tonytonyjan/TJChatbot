class SetCategoriesActive < ActiveRecord::Migration
  def up
    Category.all.each{|cat|
      cat.update_attribute :is_active, true
    }
  end

  def down
    Category.all.each{|cat|
      cat.update_attribute :is_active, nil
    }
  end
end
