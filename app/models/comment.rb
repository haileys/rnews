class Comment < ActiveRecord::Base
  attr_accessible :text, :user, :story, :comment, :story_id, :comment_id
  attr_readonly :story_id, :comment_id
  
  belongs_to :user
  belongs_to :story
  belongs_to :comment
  has_many :comments, :order => "points DESC"
  
  include Votable
  
  validates :text, :length => { :minimum => 5 }
  validates_presence_of :story_id
  validates_presence_of :user_id
  
  validate :parent_comment_is_of_same_story, :if => "comment_id"
  def parent_comment_is_of_same_story
    if comment.story != story
      errors[:story] << "is not the same as parent comment"
    end
  end
end
