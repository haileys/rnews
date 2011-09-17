class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find_by_username params[:id]
  end
  
  def create
    @user = User.new params[:user]
    if @user.save
      self.current_user = @user
      redirect_back_or_default
    else
      @errors = @user.errors
      render "new"
    end
  end
end
