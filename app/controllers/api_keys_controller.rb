class ApiKeysController < ApplicationController
  before_filter :require_sign_in
  respond_to :js

  def create
    @api_key = current_user.api_keys.create!
  end

  def destroy
    @api_key = current_user.api_keys.find params[:id]
    @api_key.destroy
  end
end
