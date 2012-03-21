class Response < ActiveRecord::Base
  belongs_to :category, :touch=>true
  validates :content, :presence=>true, :uniqueness=>true
end