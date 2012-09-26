class TweetsController < ApplicationController
  respond_to :json
  before_filter :determine_cors_request_type

  def index
  end


  private

  def determine_cors_request_type
    case request.method
    when 'GET'
      set_cors_headers
      authenticate_user
      send_twitter_json_response
    when 'OPTIONS'
      set_cors_headers
      render json: '{}'
    else
      head :unauthorized
    end
  end

  def set_cors_headers
    response.headers['Access-Control-Allow-Headers'] = '*, Authorization, X-Requested-With, X-Prototype-Version, X-CRSF-Token, Content-Type'
    response.headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    response.headers['Access-Control-Allow-Origin']  = '*'
  end

  def authenticate_user
    authenticate_with_http_basic do |username, password|
      @api_key = ApiKey.find_by_key username
    end

    head :unauthorized and return unless @api_key
    @user = @api_key.user
  end

  def send_twitter_json_response
    authorization = @user.authorizations.find_by_username params[:username]
    options = params.fetch :options, {}
    twitter_json = authorization.make_twitter_request :user_timeline, options
    render json: twitter_json
  end
end
