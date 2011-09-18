class Favorite < ActiveRecord::Base
  attr_accessible :user, :category, :user_id, :category_id
  
  belongs_to :user
  belongs_to :category
  
  validates :user, :presence => true
  validates :category, :presence => true
  
  validates_uniqueness_of :category_id, :scope => :user_id
end
