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
    session[:location] = params
    logger.info("== Saved location => #{session[:location].inspect}")
  end

  def guest_authorization
    if logged_in?
      return true
    else
      authenticate_or_request_with_http_basic do |username, password|
        username == "guest" && password == "knowledge"
      end
    end
  end
  
end
