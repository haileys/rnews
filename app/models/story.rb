class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value !~ %r{\Ahttps?://}
      record.errors[attribute] << "must begin with http:// or https://"
    end
  end
end

class Story < ActiveRecord::Base
  attr_accessible :title, :url, :category_name, :category_id
  attr_accessor :category_name
  
  belongs_to :category
  belongs_to :user
  has_many :all_comments, :order => "points DESC", :class_name => "Comment"
  has_many :comments, :order => "points DESC", :conditions => { :comment_id => nil }
  
  include Votable
  
  validates :title, :length => { :in => 2..255 }
  validates :url, :url => true
  validates :user, :presence => true
  validates :category_name, :presence => true, :if => "category.nil?"
  
  validate :validate_category_exists, :if => "category_name"
  def validate_category_exists
    if Category.find_by_name(category_name).nil?
      errors[:category_name] << "does not exist"
    end
  end
  
  before_save :set_category_with_category_name
  def set_category_with_category_name
    self.category = Category.find_by_name(category_name) if category_name
  end
end
