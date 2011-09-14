class StoriesController < ApplicationController
  before_filter :require_user, :only => [:new, :create]
    
  def new
    @story = Story.new params[:story]
  end
  
  def create
    @story = Story.new params[:story]
    @story.user = current_user
    if @story.save
      redirect_to @story
    else
      @errors = @story.errors.messages
      render "new"
    end
  end
  
  def show
    @story = Story.find params[:id]
    @category = @story.category
  end
  
  def vote
    @story = Story.find params[:id]
    vote = Vote.create(:user => current_user, :story => @story, :vote => params[:vote])
    respond_to do |f|
      f.html do
        if request.xhr?
          render :partial => "shared/story", :object => @story
        else
          redirect_to @story
        end
      end
      f.json { render :json => vote.valid? }
    end
  end
end
