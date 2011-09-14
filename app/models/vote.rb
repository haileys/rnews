class Vote < ActiveRecord::Base
  attr_accessible :vote, :story, :comment, :user
  
  belongs_to :user
  belongs_to :story
  belongs_to :comment
  
  validates :vote, :numericality => { :only_integer => true }, :inclusion => { :in => -1..1 }
  validates :user_id, :presence => true
  validates :story_id, :presence => true, :if => "comment_id.nil?"
  validates :comment_id, :presence => true, :if => "story_id.nil?"
  
  before_create :delete_existing_vote
  def delete_existing_vote
    if story_id
      Vote.find_by_user_id_and_story_id(user_id, story_id).try(:delete)
    else
      Vote.find_by_user_id_and_comment_id(user_id, comment_id).try(:delete)
    end
  end
  
  after_create :update_item_score
  def update_item_score
    if story_id
      story.recount
    else
      comment.recount
    end
  end
  
  after_create :update_user_score
  def update_user_score
    user.points += vote
    user.save!
  end
end