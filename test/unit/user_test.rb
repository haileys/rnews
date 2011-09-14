require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new(:password => "foo", :password_confirmation => "foo")
    assert !user.save
  end

  test "should not save user with non-unique username" do
    user = User.new(:username => "charlie", :password => "foo", :password_confirmation => "foo")
    assert !user.save
  end
  
  test "should not save user with invalid characters in username" do
    user = User.new(:username => "invalid!!", :password => "foo", :password_confirmation => "foo")
    assert !user.save
  end
  
  test "should not save user with short username" do
    user = User.new(:username => "me", :password => "foo", :password_confirmation => "foo")
    assert !user.save
  end
  
  test "should not save user with long username" do
    user = User.new(:username => "a"*33, :password => "foo", :password_confirmation => "foo")
    assert !user.save
  end
  
  test "should not save user without password confirmation" do
    user = User.new(:username => "test1", :password => "foobar")
    assert !user.save
  end
  
  test "should not save user with unmatching password and password confirmation" do
    user = User.new(:username => "test2", :password => "foobar", :password_confirmation => "not_foobar")
    assert !user.save
  end
  
  test "should not save user with short password" do
    user = User.new(:username => "test3", :password => "short", :password_confirmation => "short")
    assert !user.save
  end
  
  test "should save user without bio" do
    user = User.new(:username => "test4", :password => "foobar", :password_confirmation => "foobar")
    assert user.save
  end
  
  test "should save user with bio" do
    user = User.new(:username => "test5", :password => "foobar", :password_confirmation => "foobar", :bio => "this is a bio")
    assert user.save
  end
  
  test "should not mass-assign admin flag in user" do
    user = User.new(:username => "test6", :password => "foobar", :password_confirmation => "foobar", :admin => true)
    assert !user.admin
  end
  
  test "should not mass-assign points column in user" do
    user = User.new(:username => "test6", :password => "foobar", :password_confirmation => "foobar", :points => 1337)
    assert_not_equal 1337, user.points
  end
  
  test "should initialize user points to zero" do
    user = User.create(:username => "test5", :password => "foobar", :password_confirmation => "foobar", :bio => "this is a bio")
    assert_equal 0, user.points
  end
  
  test "should not validate password presence on user update" do
    charlie = users(:charlie)
    assert charlie.valid?
    charlie.points += 123
    assert charlie.save
  end
  
  test "should not update user with short password" do
    charlie = users(:charlie)
    assert !charlie.update_attributes(:password => "short")
  end
  
  test "should not update user with unmatching password and confirmation" do
    charlie = users(:charlie)
    assert !charlie.update_attributes(:password => "changed", :password_confirmation => "not_changed")
  end
  
  test "should update user password" do
    charlie = users(:charlie)
    assert !charlie.authenticate("some password")
    assert charlie.update_attributes(:password => "some password", :password_confirmation => "some password")
    assert charlie.authenticate("some password")
  end
  
  test "should not update username" do
    fanboy = users(:fanboy)
    fanboy.update_attributes(:username => "rational_thinker")
    assert_equal "fanboy", fanboy.reload.username
  end
end
