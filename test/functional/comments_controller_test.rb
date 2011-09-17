require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test "should redirect anonymous users away from new comment" do
    get :new, { :story_id => stories(:one) }
    assert_redirected_to new_session_path
    assert_equal @request.url, session[:return_url]
  end
  
  test "should show reply form for logged in users" do
    get :new, { :story_id => stories(:one).id, :id => comments(:one_one).id }, { :user_id => users(:charlie).id }
    assert_equal comments(:one_one), assigns(:replying_to)
    assert_equal stories(:one).category, assigns(:category)
    assert_select "form"
  end
  
  test "should redirect anonymous users away from create comment" do
    post :create, { :story_id => stories(:one) }
    assert_redirected_to new_session_path
  end
  
  test "should create story comments properly" do
    assert_difference "Comment.count" do
      post :create, { :story_id => stories(:one), :comment => { :text => "hello world" } },
        { :user_id => users(:charlie).id }
    end
    assert_redirected_to stories(:one)
    assert_equal users(:charlie), assigns(:comment).user
    assert_equal stories(:one), assigns(:comment).story
    assert_nil assigns(:comment).comment
  end
  
  test "should show error page for bad story comments" do
    assert_no_difference "Comment.count" do
      post :create, { :story_id => stories(:one), :comment => { :text => "z" } },
        { :user_id => users(:charlie).id }
    end
    assert_select "form"
    assert_select ".attn.bad"
    assert_equal users(:charlie), assigns(:comment).user
    assert_equal stories(:one), assigns(:comment).story
    assert_equal "z", assigns(:comment).text
    assert_nil assigns(:comment).comment
  end
  
  test "should create reply comments properly" do
    assert_difference "Comment.count" do
      post :create, { :story_id => stories(:one), :comment => { :text => "hello world", :comment_id => comments(:one_one) } },
        { :user_id => users(:charlie).id }
    end
    assert_redirected_to stories(:one)
    assert_equal users(:charlie), assigns(:comment).user
    assert_equal stories(:one), assigns(:comment).story
    assert_equal comments(:one_one), assigns(:comment).comment
  end
  
  test "should show error page for bad reply comments" do
    assert_no_difference "Comment.count" do
      post :create, { :story_id => stories(:one), :comment => { :text => "z", :comment_id => comments(:one_one) } },
        { :user_id => users(:charlie).id }
    end
    assert_select "form"
    assert_select ".attn.bad"
    assert_equal users(:charlie), assigns(:comment).user
    assert_equal stories(:one), assigns(:comment).story
    assert_equal "z", assigns(:comment).text
    assert_equal comments(:one_one), assigns(:comment).comment
  end
  
  test "should show comment to anonymous users" do
    get :show, { :story_id => stories(:one), :id => comments(:one_one) }
    assert_response :success
    assert_equal stories(:one).category, assigns(:category)
    assert_select ".comment"
    assert css_select("form").empty?
  end
  
  test "should show comment to logged in users" do
    get :show, { :story_id => stories(:one), :id => comments(:one_one) }, { :user_id => users(:charlie).id }
    assert_response :success
    assert_equal stories(:one).category, assigns(:category)
    assert_select ".comment"
    assert css_select("form").any?
  end
  
  test "should redirect away when anonymous user votes" do
    assert_no_difference "Vote.count" do
      post :vote, { :story_id => stories(:one), :id => comments(:one_one).id, :vote => 1 }
    end
    assert_redirected_to new_session_path
  end
  
  test "should give 403 when anonymous user votes" do
    assert_no_difference "Vote.count" do
      post :vote, { :story_id => stories(:one), :id => comments(:one_one).id, :vote => 1, :format => "json" }
    end
    assert_response :forbidden
  end
  
  test "should place vote" do
    assert_difference "Vote.count" do
      post :vote, { :story_id => stories(:one), :id => comments(:one_one).id, :vote => 1 }, { :user_id => users(:charlie).id }
    end
    assert_redirected_to stories(:one)
  end
  
  test "should place xhr vote" do
    assert_difference "Vote.count" do
      xhr :post, :vote, { :story_id => stories(:one), :id => comments(:one_one).id, :vote => 1 }, { :user_id => users(:charlie).id }
    end
    assert_response :success
    assert_select ".comment"
  end
  
  test "should not allow html injection" do
    c = Comment.new(:text => "<script>alert('xss')</script>", :story => stories(:one))
    c.user = users(:charlie)
    assert c.save
    
    get :show, { :story_id => c.story.id, :id => c.id }
    assert css_select(".comment script").empty?
  end
  
  test "should not remove html tags" do
    c = Comment.new(:text => "<script>alert('xss')</script>", :story => stories(:one))
    c.user = users(:charlie)
    assert c.save
    
    get :show, { :story_id => c.story.id, :id => c.id }
    assert css_select(".comment").to_s.include?("&lt;script&gt;")
  end
  
  test "should create autolinks" do
    c = Comment.new(:text => "http://foobar.com/", :story => stories(:one))
    c.user = users(:charlie)
    assert c.save
    
    get :show, { :story_id => c.story.id, :id => c.id }
    assert_select ".comment a[href=http://foobar.com/]"
  end
  
  test "should make autolinks open in a new window" do
    c = Comment.new(:text => "http://foobar.com/", :story => stories(:one))
    c.user = users(:charlie)
    assert c.save
    
    get :show, { :story_id => c.story.id, :id => c.id }
    assert_equal "_blank", css_select(".comment p a")[0].attributes["target"]
  end
  
  test "should make autolinks rel=nofollow" do
    c = Comment.new(:text => "http://foobar.com/", :story => stories(:one))
    c.user = users(:charlie)
    assert c.save
    
    get :show, { :story_id => c.story.id, :id => c.id }
    assert_equal "nofollow", css_select(".comment p a")[0].attributes["rel"]
  end
end
