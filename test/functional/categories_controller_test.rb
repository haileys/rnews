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
end
