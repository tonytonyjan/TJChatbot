class Response < ActiveRecord::Base
  belongs_to :category, :touch=>true
  belongs_to :user, :foreign_key=>:last_edit_user_id
  validates :content, :presence=>true, :uniqueness=>{:scope=>:category_id}
end