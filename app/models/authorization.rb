class Authorization < ActiveRecord::Base
  attr_accessible :user_id, :username
  belongs_to :user

  validates :user, presence: true
  validates :username, presence: true

  def oauth_authorize_url
    oauth_request_token.authorize_url force_login: 'true', screen_name: username,
      oauth_callback: oauth_callback_url
  end


  protected

  def oauth_callback_url
    "https://getmytweets.herokuapp.com/oauth/callback/#{id}"
  end

  def oauth_consumer
    @consumer ||= OAuth::Consumer.new oauth_consumer_key, oauth_consumer_secret,
      site: 'https://api.twitter.com'
  end

  def oauth_consumer_key
    ENV['TWITTER_CONSUMER_KEY']
  end

  def oauth_consumer_secret
    ENV['TWITTER_CONSUMER_SECRET']
  end

  def oauth_request_token
    @oauth_request_token ||= oauth_consumer.get_request_token oauth_callback: oauth_callback_url
  end

end
