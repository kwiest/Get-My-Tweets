class AuthorizationsController < ApplicationController
  before_filter :require_sign_in

  def new
    @authorization = current_user.authorizations.new
  end

  def create
    @authorization = current_user.authorizations.create params[:authorization]
    if @authorization.save
      redirect_to @authorization.oauth_authorize_url
    else
      render action: 'new'
    end
  end

  def destroy
    @authorization = current_user.authorizations.find params[:id]
    @authorization.destroy
    respond_to :js
  end
end
