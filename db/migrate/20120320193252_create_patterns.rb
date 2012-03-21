class CreatePatterns < ActiveRecord::Migration
  def change
    create_table :patterns do |t|
      t.string :content
      t.integer :category_id
      t.timestamps
    end
  end
end
