class TweetsController < ApplicationController
  respond_to :json

  def index
    parse_params
    authenticate_user @key
    authorization = @user.authorizations.find_by_username params[:username]
    twitter_json  = authorization.make_twitter_request :user_timeline, @options
    render json: twitter_json
  end


  private

  def parse_params
    @key     = params.fetch :api_key
    @options = params.fetch :options, {}
  rescue KeyError
    Rails.logger.info 'No API Key passed'
    head :unauthorized
  end

  def authenticate_user(key)
    api_key = ApiKey.find_by_key! key
    @user   = api_key.user
  rescue ActiveRecord::RecordNotFound
    Rails.logger.info 'Could not find API key record or User'
    head :unauthorized
  end

  def set_cors_headers
    Rails.logger.info 'Setting CORS Headers'
    response.headers['Access-Control-Allow-Headers'] = '*, Authorization, X-Requested-With, X-Prototype-Version, X-CRSF-Token, Content-Type'
    response.headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    response.headers['Access-Control-Allow-Origin']  = '*'
  end
end
