class AuthorizationsController < ApplicationController
  before_filter :require_sign_in
  before_filter :assign_authorization, only: %w(show update destroy)

  def show
  end

  def new
    @authorization = current_user.authorizations.new
  end

  def create
    @authorization = current_user.authorizations.create params[:authorization]
    if @authorization.save
      session[:request_token], session[:request_token_secret] = @authorization.request_tokens
      redirect_to @authorization.oauth_authorize_url
    else
      render action: 'new'
    end
  end

  def update
    if @authorization.authorize_with_twitter session[:request_token],
      session[:request_token_secret], params[:oauth_verifier]
      redirect_to root_path, notice: 'Twitter account successfully authorized.'
    else
      redirect_to root_path, alert: 'Could not authorize account with Twitter.'
    end
  end

  def destroy
    @authorization.destroy
    respond_to :js
  end


  protected

  def assign_authorization
    @authorization = current_user.authorizations.find params[:id]
  end
end
