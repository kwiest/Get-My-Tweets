class Authorization < ActiveRecord::Base
  attr_accessible :user_id, :username
  belongs_to :user

  validates :user, presence: true
  validates :username, presence: true

  before_create :generate_oauth_request_token

  def oauth_authorize_url
    "https://api.twitter.com/oauth/authorize?oauth_token=#{oauth_token}&force_login=true&screename=#{username}"
  end


  protected

  def generate_oauth_request_token
    request_token = oauth_consumer.get_request_token callback: oauth_callback_url
    self.oauth_token = request_token.params.fetch :oauth_token
  end

  def oauth_callback_url
    'https://mytweets.herokuapp.com/oauth/callback'
  end

  def oauth_consumer
    @consumer ||= OAuth::Consumer.new oauth_consumer_key, oauth_consumer_secret,
      site: 'https://api.twitter.com/'
  end

  def oauth_consumer_key
    ENV['TWITTER_CONSUMER_KEY']
  end

  def oauth_consumer_secret
    ENV['TWITTER_CONSUMER_SECRET']
  end

end
