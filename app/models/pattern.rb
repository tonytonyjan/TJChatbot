# encoding: utf-8
class Pattern < ActiveRecord::Base
  belongs_to :category, :touch=>true
  belongs_to :user, :foreign_key=>:last_edit_user_id
  validates :content, :presence=>true, :uniqueness=>{:scope=>:category_id}
  
  validate :pattern_must_be_regex
  
  def pattern_must_be_regex
    begin
      Regexp.new(content)
    rescue
      errors.add(:content, "is not a valid regular expression.")
    end
  end
end
