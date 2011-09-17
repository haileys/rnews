require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should show register form" do
    get :new
    assert_response :success
  end
  
  test "should show errors and not create user" do
    assert_no_difference "User.count" do
      post :create, { :user => { } }
    end
    assert_select ".attn.bad"
    assert_select ".field_with_errors" do
      assert_select "#user_username"
      assert_select "#user_password"
    end
  end
  
  test "should create user" do
    assert_difference "User.count" do
      post :create, { :user => { :username => "zzz", :password => "foobar", :password_confirmation => "foobar", :bio => "test bio" } }
    end
    assert_redirected_to "/"
    assert_not_equal nil, session[:user_id]
    user = @controller.current_user.reload
    assert_equal "zzz", user.username
    assert_equal "test bio", user.bio
    assert user.authenticate("foobar")
  end
  
  test "should create user and return to url" do
    assert_difference "User.count" do
      post :create, { :user => { :username => "zzz123", :password => "foobar", :password_confirmation => "foobar", :bio => "test bio" } },
        { :return_url => stories(:one) }
    end
    assert_redirected_to stories(:one)
  end
  
  test "should show user" do
    get :show, { :id => "charlie" }
    assert_response :success
    assert_select ".content_box.larger h2", "charlie's posts"
    assert_select ".user_posts .linkbox"
    assert_select ".user_posts .comment"
    assert_equal users(:charlie).points, css_select(".info_points .total")[0].children[0].content.split(" ")[0].to_i
  end
end
