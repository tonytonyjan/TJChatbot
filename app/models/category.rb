# encoding: utf-8
class Category < ActiveRecord::Base
  scope :actived, where(:is_active => true)
  scope :unactived, where(:is_active => false)
  scope :public, where(:user_id=>nil)
  
  has_many :patterns, :dependent=>:destroy
  has_many :responses, :dependent=>:destroy
  belongs_to :user
  
  accepts_nested_attributes_for :patterns, :responses, :reject_if=>proc { |attributes| attributes[:content].blank? }, :allow_destroy=>true
  
  validates :name, :presence=>true, :uniqueness=>{:scope=>:user_id}
  validate :pattern_fields_cannot_be_blank, :response_fields_cannot_be_blank
  
  def pattern_fields_cannot_be_blank
    errors.add(:pattern, "fields can't be blank") if self.patterns.blank?
  end
  
  def response_fields_cannot_be_blank
    errors.add(:response, "fields can't be blank") if self.responses.blank?
  end
  
  # Search categories' title
  def self.search_by_title query
    Category.where(["user_id IS NULL AND name LIKE ?", "%#{query}%"])
  end
  
  # Search categories that can accept the query.
  def self.search_by_pattern query
    cats = []
    Category.all.each{|cat|
      cats << cat if cat.public? && cat.match?(query)
    }
    return cats
  end
  
  # opt[:p] for pattern
  # opt[:t] for title
  def self.search opt={}
    ret = []
    ret |= search_by_title(opt[:q]) if opt[:t]
    ret |= search_by_pattern(opt[:q]) if opt[:p]
    return ret
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
  
  def public?
    ! user
  end
  
  def private?
    user
  end
  
  def recent_patterns
    patterns.sort_by(&:updated_at).reverse
  end
  
  def recent_responses
    responses.sort_by(&:updated_at).reverse
  end
end
