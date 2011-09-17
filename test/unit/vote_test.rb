require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test "should not save vote without vote" do
    vote = Vote.new(:user => users(:charlie), :story => stories(:one))
    assert !vote.save
    assert vote.errors.messages[:vote]
  end

  test "should not save vote with +ve out of bounds vote" do
    vote = Vote.new(:vote => 2, :user => users(:charlie), :story => stories(:one))
    assert !vote.save
    assert vote.errors.messages[:vote]
  end
  
  test "should not save vote with -ve out of bounds vote" do
    vote = Vote.new(:vote => -2, :user => users(:charlie), :story => stories(:one))
    assert !vote.save
    assert vote.errors.messages[:vote]
  end
  
  test "should not save vote with non-numeric vote" do
    vote = Vote.new(:vote => "foo", :user => users(:charlie), :story => stories(:one))
    assert !vote.save
    assert vote.errors.messages[:vote]
  end

  test "should not save vote without user" do
    vote = Vote.new(:vote => 1, :story => stories(:one))
    assert !vote.save
    assert vote.errors.messages[:user]
  end
  
  test "should not save vote without story or comment" do
    vote = Vote.new(:vote => 1, :user => users(:charlie))
    assert !vote.save
    assert vote.errors.messages[:story]
    assert vote.errors.messages[:comment]
  end
  
  test "should not save vote with both story and comment" do
    vote = Vote.new(:vote => 1, :user => users(:charlie), :story => stories(:one), :comment => comments(:one_one))
    assert !vote.save
    assert vote.errors.messages[:base]
  end
  
  test "should save vote with story" do
    vote = Vote.new(:vote => 1, :story => stories(:one), :user => users(:charlie))
    assert vote.save
  end
  
  test "should save vote with comment" do
    vote = Vote.new(:vote => 1, :comment => comments(:two_one), :user => users(:charlie))
    assert vote.save
  end
end
