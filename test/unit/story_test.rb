require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  test "should not save story without user" do
    story = Story.new(:title => "test", :url => "http://does.not.exist/", :category_name => "general")
    assert !story.save
    assert story.errors.messages[:user]
  end
  
  test "should not save story without title" do
    story = Story.new(:url => "http://does.not.exist/", :category_name => "general")
    story.user = users(:charlie)
    assert !story.save
    assert story.errors.messages[:title]
  end
  
  test "should not save story with short title" do
    story = Story.new(:title => "a", :url => "http://does.not.exist/", :category_name => "general")
    story.user = users(:charlie)
    assert !story.save
    assert story.errors.messages[:title]
  end
  
  test "should not save story with long title" do
    story = Story.new(:title => "a"*256, :url => "http://does.not.exist/", :category_name => "general")
    story.user = users(:charlie)
    assert !story.save
    assert story.errors.messages[:title]
  end
  
  test "should not save story without url" do
    story = Story.new(:title => "test", :category_name => "general")
    story.user = users(:charlie)
    assert !story.save
    assert story.errors.messages[:url]
  end
  
  test "should not save story with protocol-less url" do
    story = Story.new(:title => "test", :url => "does.not.exist/", :category_name => "general")
    story.user = users(:charlie)
    assert !story.save
    assert story.errors.messages[:url]
  end

  test "should not save story with bad protocol in url" do
    story = Story.new(:title => "test", :url => "javascript:alert(document.cookie)", :category_name => "general")
    story.user = users(:charlie)
    assert !story.save
    assert story.errors.messages[:url]
  end

  test "should not save story without category name" do
    story = Story.new(:title => "test", :url => "http://google.com")
    story.user = users(:charlie)
    assert !story.save, "saved anyway"
    assert story.errors.messages[:category_name], story.errors.messages.inspect
  end
  
  test "should not save story with unknown category name" do
    story = Story.new(:title => "test", :url => "http://google.com", :category_name => "this category doesn't exist")
    story.user = users(:charlie)
    assert !story.save
    assert story.errors.messages[:category_name]
  end
  
  test "should save story with category id rather than name" do
    story = Story.new(:title => "test", :url => "http://google.com", :category_id => categories(:general).id)
    story.user = users(:charlie)
    assert story.save
    assert_equal categories(:general), story.category
  end
  
  test "should save story with http url" do
    story = Story.new(:title => "test", :url => "http://google.com", :category_name => "general")
    story.user = users(:charlie)
    assert story.save, story.errors.messages.inspect
  end
  
  test "should save story with https url" do
    story = Story.new(:title => "test", :url => "https://encrypted.google.com", :category_name => "general")
    story.user = users(:charlie)
    assert story.save, story.errors.messages.inspect
  end
  
  test "should show comments in descending order by points" do
    story = stories(:one)
    last = nil
    story.comments.each do |c|
      assert(last.nil? || c.points < last)
      last = c.points
    end
  end
  
  test "should set category from category_name" do
    story = Story.new(:title => "test", :url => "http://does.not.exist/", :category_name => "general")
    story.user = users(:charlie)
    assert story.save, "didn't save"
    assert_equal categories(:general), story.reload.category
  end
  
  test "should only return top level comments from #comments" do
    assert stories(:one).comments.all? { |c| c.comment == nil }
  end
  
  test "should return all comments from #all_comments" do
    c = stories(:one).all_comments
    assert c.any? { |c| c.comment == nil }
    assert c.any? { |c| c.comment != nil }
  end
end
