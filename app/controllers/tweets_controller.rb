class TweetsController < ApplicationController
  respond_to :json
  before_filter :set_cors_headers
  before_filter :authenticate_user
  skip_before_filter :verifty_authenticity_token

  def index
    authorization = @user.authorizations.find_by_username params[:username]
    options = params.fetch :options, {}
    timeline = authorization.make_twitter_request :user_timeline, options
    render json: timeline
  end


  private

  def authenticate_user
    authenticate_with_http_basic do |username, password|
      @api_key = ApiKey.find_by_key username
    end
    head :unauthorized and return unless @api_key
    @user = @api_key.user
  end

  def set_cors_headers
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    response.headers['Access-Control-Allow-Headers'] = '*, Authorization, X-Requested-With, X-Prototype-Version, X-CRSF-Token, Content-Type'
    response.headers['Access-Control-Allow-Methods'] = 'GET'
    response.headers['Access-Control-Allow-Origin']  = '*'
  end
end
