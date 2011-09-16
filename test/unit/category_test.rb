require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should not save category without name" do
    cat = Category.new
    cat.user = users(:charlie)
    assert !cat.save
  end
  
  test "should not save category with short name" do
    cat = Category.new(:name => "a")
    cat.user = users(:charlie)
    assert !cat.save
  end

  test "should not save category with long name" do
    cat = Category.new(:name => "a"*65)
    cat.user = users(:charlie)
    assert !cat.save
  end
  
  test "should not save category with non-unique name" do
    cat = Category.new(:name => "general")
    cat.user = users(:charlie)
    assert !cat.save
  end
  
  test "should not save category with invalid characters" do
    cat = Category.new(:name => "invalid!")
    cat.user = users(:charlie)
    assert !cat.save
  end
  
  test "should not save category without user" do
    cat = Category.new(:name => "a")
    assert !cat.save
  end
  
  test "should save category" do
    cat = Category.new(:name => "new_category")
    cat.user = users(:charlie)
    assert cat.save, Proc.new { cat.errors.messages.inspect }
  end
  
  test "should return name for to_param" do
    cat = Category.first
    assert_equal cat.to_param, cat.name
  end
  
  test "should have array for Category::VIEWS" do
    assert_instance_of Array, Category::VIEWS
  end
  
  test "should return categories in descending chronological order for Category#newest" do
    last = nil
    Category.newest.each do |c|
      assert(last.nil? || last >= c.created_at)
      last = c.created_at
    end
  end
  
  test "should return categories in descending order of number of posts in the last 48 hours for Category#active" do
    last = nil
    Category.active.each do |c|
      n = c.stories.where("created_at > ?", Time.now - 2.days).count
      assert(last.nil? || last >= n)
      last = n
    end
  end
end
