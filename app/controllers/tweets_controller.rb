class TweetsController < ApplicationController
  respond_to :json
  skip_before_filter :verifty_authenticity_token

  REQUEST_METHODS = {
    'GET'     => :authenticate_user,
    'OPTIONS' => :set_cors_headers
  }

  def index
    send REQUEST_METHODS[request.method]
  end


  private

  def authenticate_user
    authenticate_with_http_basic do |username, password|
      @api_key = ApiKey.find_by_key username
    end

    head :unauthorized and return unless @api_key
    @user = @api_key.user
    send_json_response
  end

  def set_cors_headers
    response.headers['Access-Control-Allow-Headers'] = '*, Authorization, X-Requested-With, X-Prototype-Version, X-CRSF-Token, Content-Type'
    response.headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    response.headers['Access-Control-Allow-Origin']  = '*'
    render json: '{}'
  end

  def send_json_response
    authorization = @user.authorizations.find_by_username params[:username]
    options = params.fetch :options, {}
    timeline = authorization.make_twitter_request :user_timeline, options
    render json: timeline
  end
end
