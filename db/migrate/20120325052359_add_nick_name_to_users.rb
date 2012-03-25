class AddNickNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nick_name, :string

  end
end
