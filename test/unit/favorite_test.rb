require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  test "should create favorite" do
    favorite = Favorite.create(:user => users(:charlie), :category => categories(:general))
    assert favorite.save
  end
  
  test "should not create favorite without user" do
    favorite = Favorite.create(:category => categories(:general))
    assert !favorite.save
    assert favorite.errors.messages[:user]
  end
  
  test "should not create favorite without category" do
    favorite = Favorite.create(:user => users(:charlie))
    assert !favorite.save
    assert favorite.errors.messages[:category]
  end
  
  test "should not create favorite that already exists" do
    favorite = Favorite.create(:user => users(:fanboy), :category => categories(:general))
    assert !favorite.save
  end
  
  test "should find number of favorites a user has" do
    assert_equal 2, users(:fanboy).favorite_categories.count
  end
  
  test "should test that a user has favorited a category" do
    assert users(:fanboy).favorite_categories.include?(categories(:general))
    assert !users(:charlie).favorite_categories.include?(categories(:general))
  end
  
  test "should add favorite category with <<" do
    charlie = users(:charlie)
    assert_difference "charlie.favorite_categories.count" do
      charlie.favorite_categories << categories(:general)
    end
  end
  
  test "should remove category" do
    fanboy = users(:fanboy)
    assert_difference "fanboy.favorite_categories.count", -1 do
      fanboy.favorite_categories.delete categories(:general)
    end
  end
end