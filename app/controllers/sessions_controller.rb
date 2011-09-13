class SessionsController < ApplicationController
  def destroy
    session[:user_id] = nil
    redirect_back_or_default request.referer
  end
  
  def create
    user = User.find_by_username(params[:username]).try(:authenticate, params[:password])
    if user
      self.current_user = user
      redirect_back_or_default
    else
      @errors = "Incorrect username or password"
      render "new"
    end
  end
  
  def new
  end
end
