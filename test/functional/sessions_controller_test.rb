require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get login page" do
    get :new
    assert_response :success
  end
  
  test "should create session" do
    post :create, { :username => "charlie", :password => "foo" }
    assert_equal users(:charlie), @controller.current_user
    assert_equal users(:charlie).id, session[:user_id]
    assert_redirected_to "/"
  end
  
  test "should not create session" do
    post :create, { :username => "charlie", :password => "bar" }
    assert_nil session[:user_id]
    assert_select ".attn.bad"
  end
  
  test "should logout" do
    get :destroy, {}, { :uid => users(:charlie) }
    assert_nil @controller.current_user
    assert_nil session[:user_id]
    assert_redirected_to "/"
  end
  
  test "should logout and return to url" do
    get :destroy, {}, { :uid => users(:charlie), :return_url => stories(:one) }
    assert_redirected_to stories(:one)
  end
  
  test "should login and return to url" do
    post :create, { :username => "charlie", :password => "foo" }, { :return_url => stories(:one) }
    assert_redirected_to stories(:one)
  end
end
