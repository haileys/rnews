module Votable
  def self.included(other)
    other.class_eval do
      has_many :votes
      has_many :upvotes, :class_name => "Vote", :conditions => "vote > 0"
      has_many :downvotes, :class_name => "Vote", :conditions => "vote < 0"
      has_many :upvoting_users, :class_name => "User", :through => :votes, :source => :user, :conditions => "votes.vote > 0"
      has_many :downvoting_users, :class_name => "User", :through => :votes, :source => :user, :conditions => "votes.vote < 0"

      before_create :set_points_to_zero
      def set_points_to_zero
        self.points = 0
      end

      def recount
        self.points = votes.sum "vote"
        save!
      end
    end
  end
end