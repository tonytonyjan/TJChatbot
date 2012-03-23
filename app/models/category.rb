# encoding: utf-8
class Category < ActiveRecord::Base
  has_many :patterns, :dependent=>:destroy
  has_many :responses, :dependent=>:destroy
  accepts_nested_attributes_for :patterns, :responses, :reject_if=>proc { |attributes| attributes[:content].blank? }, :allow_destroy=>true
  
  validates :name, :presence=>true, :uniqueness=>true
  
  # Search categories' title
  def self.search_by_title query
    Category.all :conditions=>["name LIKE ?", "%"+query+"%"]
  end
  
  # Search categories that can accept the query.
  def self.search_by_pattern query
    cats = []
    Category.all.each{|cat|
      cats << cat if cat.match?(query)
    }
    return cats
  end
  
  # Check if the given string can be accepted by this category.
  def match? string
    match = false
    patterns.each{|p|
      p string, p, "==="
      if string =~ Regexp.new(p.content)
        match = true
        break
      end
    }
    return match
  end
  
  def recent_patterns
    patterns.sort_by(&:updated_at).reverse
  end
  
  def recent_responses
    responses.sort_by(&:updated_at).reverse
  end
end
