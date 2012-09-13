class TweetsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user

  def index
    authorization = @user.authorizations.find_by_username params[:username]
    render json: authorization.make_twitter_request(:user_timeline)
  end


  private

  def authenticate_user
    authenticate_with_http_basic do |username, password|
      @api_key = ApiKey.find_by_key username
    end
    head :unauthorized unless @api_key
    @user = @api_key.user
  end
end
