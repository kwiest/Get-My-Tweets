class Authorization < ActiveRecord::Base
  attr_accessible :user_id, :username, :oauth_token, :oauth_token_secret, :authorized
  belongs_to :user

  validates :user, presence: true
  validates :username, presence: true


  def authorize_with_twitter(request_token, request_token_secret, oauth_verifier)
    access_token = build_oauth_access_token request_token, request_token_secret, oauth_verifier
    if twitter_client.authorized?
      update_attributes oauth_token: access_token.token,
        oauth_token_secret: access_token.secret, authorized: true
      true
    else
      false
    end
  end

  def make_twitter_request(resource)
    raise 'Unauthorized Request' unless authorized?
    authorized_twitter_client.send resource
  end

  def oauth_authorize_url
    twitter_request_token.authorize_url force_login: 'true', screen_name: username,
      oauth_callback: oauth_callback_url
  end

  def request_tokens
    [twitter_request_token.token, twitter_request_token.secret]
  end


  private

  def authorized_twitter_client
    TwitterOAuth::Client.new consumer_key: ENV['TWITTER_CONSUMER_KEY'],
      consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
      token: oauth_token, secret: oauth_token_secret
  end

  def build_oauth_access_token(request_token, request_token_secret, oauth_verifier)
    twitter_client.authorize request_token, request_token_secret, oauth_verifier: oauth_verifier
  end

  def oauth_callback_url
    "#{ENV['TWITTER_CALLBACK_URL']}/#{id}"
  end

  def twitter_client
    @twitter_client ||= TwitterOAuth::Client.new consumer_key: ENV['TWITTER_CONSUMER_KEY'],
      consumer_secret: ENV['TWITTER_CONSUMER_SECRET']
  end

  def twitter_request_token
    @twitter_request_token ||= twitter_client.request_token oauth_callback: oauth_callback_url
  end
end
