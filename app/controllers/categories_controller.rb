class CategoriesController < ApplicationController
  def index
    @category_views = Category::VIEWS.map { |v| [v, Category.send(v)] }
  end
  def show
    @category = Category.find_by_name! params[:id]
    @views = @category.views
    @view = @views.include?(params[:view]) ? params[:view] : @views.first
    @stories = @category.send @view
  end
end