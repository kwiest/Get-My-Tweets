class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
  end
  helper_method :current_user

  def require_no_user
    redirect_to root_path, alert: 'Already signed-in.' if current_user
  end

  def require_sign_in
    redirect_to root_path, alert: 'You must sign-in.' unless current_user
  end
end
