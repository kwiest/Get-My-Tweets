class UsersController < ApplicationController
  before_filter :require_no_user, only: %w(new create)
  before_filter :require_sign_in, only: %w(show destroy)

  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create params[:user]
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Success! Now get your tweets.'
    else
      render action: 'new'
    end
  end

  def destroy

  end
end
