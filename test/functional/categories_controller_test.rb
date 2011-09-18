require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:category_views)
    assert_equal Category::VIEWS, assigns(:category_views).map(&:first)
  end
  
  test "should show existing category with explicit view" do
    cat = categories(:general)    
    get :show, { :id => cat.name, :view => "top" }
    
    assert_response :success
    assert_equal "top", assigns(:view)
    assert_equal cat, assigns(:category)
    assert_equal cat.views, assigns(:views)

    assert_equal cat.top, assigns(:stories)
  end
  
  test "should show existing category with top view as default" do
    get :show, { :id => "general" }    
    assert_response :success
    assert_equal "top", assigns(:view)
  end
  
  test "should show filled in favorite star for favorite category" do
    get :show, { :id => "general" }, { :user_id => users(:fanboy).id }
    assert_response :success
    assert_select "form.favorite input[type=submit]"
    assert css_select("form.favorite input[type=submit]")[0].attributes["value"], "&#9733;"
  end
  
  test "should show unfilled star for un-favorited category" do
    get :show, { :id => "ranking_test" }, { :user_id => users(:fanboy).id }
    assert_response :success
    assert_select "form.favorite input[type=submit]"
    assert css_select("form.favorite input[type=submit]")[0].attributes["value"], "&#9734;"
  end
  
  test "should show existing category with top view as default when unknown view is specified" do
    get :show, { :id => "general", :view => "foobar" }
    assert_response :success
    assert_equal "top", assigns(:view)
  end
  
  test "should show 404 for unknown category" do
    assert_raises(ActiveRecord::RecordNotFound) { get :show, { :id => "nonexistant" } }
  end
  
  test "should show 404 for unknown category with explicit view" do
    assert_raises(ActiveRecord::RecordNotFound) { get :show, { :id => "nonexistant", :view => "newest" } }
  end
  
  test "should subscribe to category" do
    charlie = users(:charlie)
    assert_difference "charlie.favorite_categories.count" do
      post :subscribe, { :id => categories(:general).name }, { :user_id => charlie.id }
    end
    assert_redirected_to categories(:general)
    assert charlie.favorite_categories.include?(categories(:general))
  end
  
  test "should unsubscribe to category" do
    fanboy = users(:fanboy)
    assert_difference "fanboy.favorite_categories.count", -1 do
      post :unsubscribe, { :id => categories(:general).name }, { :user_id => fanboy.id }
    end
    assert_redirected_to categories(:general)
    assert !fanboy.favorite_categories.include?(categories(:general))
  end
  
  test "should ajax subscribe to category" do
    charlie = users(:charlie)
    assert_difference "charlie.favorite_categories.count" do
      xhr :post, :subscribe, { :id => categories(:general).name }, { :user_id => charlie.id }
    end
    assert_response :success
    assert charlie.favorite_categories.include?(categories(:general))
  end
  
  test "should ajax unsubscribe to category" do
    fanboy = users(:fanboy)
    assert_difference "fanboy.favorite_categories.count", -1 do
      xhr :post, :unsubscribe, { :id => categories(:general).name }, { :user_id => fanboy.id }
    end
    assert_response :success
    assert !fanboy.favorite_categories.include?(categories(:general))
  end
end