class CommentsController < ApplicationController
  before_filter :require_user, :only => [:new, :create, :vote]
  
  def new
    @story = Story.find params[:story_id]
    @replying_to = Comment.find_by_id(params[:id])
    @category = @replying_to.story.category
    @comment = Comment.new(:comment => @replying_to, :story => @story)
  end
  
  def create
    @story = Story.find params[:story_id]
    @comment = Comment.new(params[:comment])
    @comment.story = @story
    @comment.user = current_user
    if @comment.save
      respond_to do |f|
        f.html { redirect_to story_path(@comment.story) }
        f.json { render :json => @comment }
      end
    else
      respond_to do |f|
        f.html do
          @errors = @comment.errors
          render "new"
        end
        f.json { render :json => @comment, :with => @comment.errors.messages }
      end
    end
  end
  
  def show
    @comment = Comment.find params[:id]
    @category = @comment.story.category
  end
  
  def vote
    @comment = Comment.find params[:id]
    vote = Vote.create(:user => current_user, :comment => @comment, :vote => params[:vote])
    respond_to do |f|
      f.html do
        if request.xhr?
          render :partial => "shared/comment", :object => @comment
        else
          redirect_to @comment
        end
      end
      f.json { render :json => vote.valid? }
    end
  end
end
