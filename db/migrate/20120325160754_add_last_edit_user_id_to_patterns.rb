class AddLastEditUserIdToPatterns < ActiveRecord::Migration
  def change
    add_column :patterns, :last_edit_user_id, :integer

  end
end
