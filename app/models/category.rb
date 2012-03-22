# encoding: utf-8
class Category < ActiveRecord::Base
  has_many :patterns, :dependent=>:destroy
  has_many :responses, :dependent=>:destroy
  accepts_nested_attributes_for :patterns, :responses, :reject_if=>proc { |attributes| attributes[:content].blank? }, :allow_destroy=>true
  
  validates :name, :presence=>true, :uniqueness=>true
  
  
  def self.search query=nil
    if query.present?
      all :conditions=>["name LIKE '%?%'", query.force_encoding("UTF-8")]
    else
      all
    end
  end
  
  def recent_patterns
    patterns.sort_by(&:updated_at).reverse
  end
  
  def recent_responses
    responses.sort_by(&:updated_at).reverse
  end
end
