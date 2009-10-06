# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password

  helper_method :current_user, :logged_in?

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    @current_user = current_user_session && current_user_session.record
  end

  def login_required
    if logged_in?
      return true
    else
      flash[:error] = "You must be logged in to do that!"
      redirect_to login_path
      return false
    end
  end

  def logged_in?
    not (current_user.nil? || current_user == false)
  end

  def redirect_back_or_default(path=nil)
    redirect_to (session[:location] || path || root_path)
  end

  def save_location
    session[:location] = {:controller => params[:controller], :action => params[:action], :id => params[:id]}
    logger.info("== Saved location => #{session[:location].inspect}")
  end

  def admin_required
    authenticate_or_request_with_http_basic do |username, password|
      admin_auth?(username, password)
    end
  end

  def guest_required
    unless logged_in?
      authenticate_or_request_with_http_basic do |username, password|
        guest_auth?(username,password) || admin_auth?(username, password)
      end
    end
  end

  def admin_auth?(username, password)
    (username == "admin" && password == Settings.auth.admin )
  end

  def guest_auth?(username,password)
    (username == "guest" && password == Settings.auth.guest)
  end

end
