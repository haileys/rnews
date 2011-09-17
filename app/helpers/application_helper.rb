module ApplicationHelper
  
  def current_user=(user)
    session[:user_id] = user.try :id
    @current_user = user
  end
  
  def current_user
    @current_user
  end
  
  def site_config(key)
    Rnews::Application::APP_CONFIG[key.to_s]
  end
end
