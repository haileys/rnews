require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  test "should show story submission form for logged in users" do
    get :new, {}, { :user_id => users(:charlie).id }
    assert_response :success
    assert assigns(:story)
    assert_select "form"
  end
  
  test "new story should redirect to login screen for anonymous users" do
    get :new
    assert_redirected_to new_session_path
    assert_equal @request.url, session[:return_url]
  end
  
  test "should redirect anonymous users away from create story" do
    @request.env["HTTP_REFERER"] = "/stories/new"
    post :create, { :story => { :title => "test", :url => "http://test.url/", :category_name => "general" } }
    assert_redirected_to new_session_path
    assert_equal @request.referer, session[:return_url]
  end

  test "should not create story" do
    assert_no_difference "Story.count" do
      post :create, { :story => { } }, { :user_id => users(:charlie).id }
    end
    assert assigns(:story)
    assert_select ".attn.bad"
  end
  
  test "should create story and redirect" do
    assert_difference "Story.count" do
      post :create, { :story => { :title => "test", :url => "http://test.url/", :category_name => "general" } },
        { :user_id => users(:charlie).id }
    end
    assert_redirected_to assigns(:story)
  end
  
  test "should show story to anonymous user" do
    get :show, { :id => stories(:one).id }
    assert_equal stories(:one), assigns(:story)
    assert_equal stories(:one).category, assigns(:category)
    
    assert css_select("form").empty?
  end
  
  test "should show story to authenticated user" do
    get :show, { :id => stories(:one).id }
    assert_equal stories(:one), assigns(:story)
    assert_equal stories(:one).category, assigns(:category)
  end
  
  test "should show 404 for unknown story" do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, { :id => -1 }
    end
  end
  
  test "should redirect away when anonymous user votes" do
    assert_no_difference "Vote.count" do
      post :vote, { :id => stories(:one).id, :vote => 1 }
    end
    assert_redirected_to new_session_path
  end
  
  test "should give 403 when anonymous user votes" do
    assert_no_difference "Vote.count" do
      post :vote, { :id => stories(:one).id, :vote => 1, :format => "json" }
    end
    assert_response :forbidden
  end
  
  test "should place vote" do
    assert_difference "Vote.count" do
      post :vote, { :id => stories(:one).id, :vote => 1 }, { :user_id => users(:charlie).id }
    end
    assert_redirected_to stories(:one)
  end
  
  test "should place xhr vote" do
    assert_difference "Vote.count" do
      xhr :post, :vote, { :id => stories(:one).id, :vote => 1 }, { :user_id => users(:charlie).id }
    end
    assert_response :success
    assert_select ".linkbox"
  end
end
