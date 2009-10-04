class UserSessionsController < ApplicationController
  skip_before_filter :store_location
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_back_or_default
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    session[:location] = nil
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end

end
