class AddLastEditUserIdToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :last_edit_user_id, :integer

  end
end
