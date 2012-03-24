class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :plurk_id
      t.text :user_info
      t.string :access_token
      t.timestamps
    end
  end
end
