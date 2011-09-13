class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include ApplicationHelper
  
  before_filter :set_current_user
  def set_current_user
    self.current_user = User.find_by_id session[:user_id]
  end
  
  before_filter :set_error_from_flash_error
  def set_error_from_flash_error
    @errors = flash[:errors]
  end
  
  def require_user
    unless current_user
      store_return_url
      respond_to do |f|
        f.html do
          flash[:errors] = "You need to be logged in to do that"
          redirect_to new_session_path
        end
        f.any  { head :forbidden }
      end
      return false
    end
  end
  
  def store_return_url
    session[:return_url] = 
      if request.get?
        request.url
      else
        request.referer
      end
  end
  
  def redirect_back_or_default(default = nil)
    default ||= "/"
    redirect_to(session[:return_url] || default)
    session[:return_url] = nil
  end
end
