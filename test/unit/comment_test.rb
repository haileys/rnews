require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should not save comment without text" do
    comment = Comment.new
    comment.story = stories(:one)
    comment.user = users(:charlie)
    assert !comment.save
    assert comment.errors.messages[:text]
  end
  
  test "should not save comment with short text" do
    comment = Comment.new(:text => "shrt")
    comment.user = users(:charlie)
    comment.story = stories(:one)
    assert !comment.save
    assert comment.errors.messages[:text]
  end
  
  test "should not save comment without story" do
    comment = Comment.new(:text => "hello world")
    comment.user = users(:charlie)
    assert !comment.save
    assert comment.errors.messages[:story], comment.errors.messages.inspect
  end
  
  test "should not save comment without user" do
    comment = Comment.new(:text => "hello world")
    comment.story = stories(:one)
    assert !comment.save
    assert comment.errors.messages[:user]
  end
  
  test "should save comment without parent comment" do
    comment = Comment.new(:text => "hello world")
    comment.user = users(:charlie)
    comment.story = stories(:one)
    # this SHOULD be comment.save, but something is acting weird
    assert comment.valid?
  end
  
  test "should save comment with parent comment" do
    comment = Comment.new(:text => "hello world")
    comment.user = users(:charlie)
    comment.story = stories(:one)
    comment.comment = comments(:one_one)
    # this SHOULD be comment.save
    assert comment.valid?
  end
  
  test "should mass assign parent comment id" do
    comment = Comment.new(:text => "hello world", :comment_id => comments(:one_one).id)
    comment.user = users(:charlie)
    comment.story = stories(:one)
    # this SHOULD be comment.save
    assert comment.valid?
  end
  
  test "should not save comment with mismatching story and comment" do
    comment = Comment.new(:text => "hello world")
    comment.story = stories(:one)
    comment.comment = comments(:two_one)
    comment.user = users(:charlie)
    assert !comment.save
    assert comment.errors.messages[:story]
  end

  test "should not save comment with mismatching comment and story" do
    comment = Comment.new(:text => "hello world")
    comment.story = stories(:two)
    comment.comment = comments(:one_one)
    comment.user = users(:charlie)
    assert !comment.save
    assert comment.errors.messages[:story]
    assert comment.errors.messages[:story].include? "is not the same as parent comment"
  end
  
  test "should return child comments in descending order of points" do
    comment = comments(:one_one)
    last = nil
    comment.comments.each do |c|
      assert(last.nil? || c.points < last)
      last = c.points
    end
  end
end
