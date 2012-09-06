class SessionsController < ApplicationController
  def create
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Welcome back!'
    else
      redirect_to root_path, alert: 'Unable to sign-in, please try again.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed-out, come back soon.'
  end
end
