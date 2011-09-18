class CategoriesController < ApplicationController
  before_filter :require_user, :only => [:favorite, :unfavorite]
  
  def index
    @category_views = Category::VIEWS.map { |v| [v, Category.send(v)] }
  end
  
  def show
    @category = Category.find_by_name! params[:id]
    @views = @category.views
    @view = @views.include?(params[:view]) ? params[:view] : @views.first
    @stories = @category.send @view
  end
  
  [:subscribe, :unsubscribe].each do |act|
    define_method act do
      @category = Category.find_by_name! params[:id]
      current_user.send act, @category
    
      respond_to do |f|
        f.html do
          if request.xhr?
            render :partial => "shared/category", :object => @category
          else
            redirect_to @category
          end
        end
        f.json { render :json => true }
      end
    end
  end
end