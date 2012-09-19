require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
  def setup
    @kyle = users :kyle
    @authorization = @kyle.authorizations.create! username: 'test'
  end

  # Validations
  should validate_presence_of(:user)
  should validate_presence_of(:username)

  # Associations
  should belong_to(:user)


  def test_retrieving_request_tokens
    VCR.use_cassette 'twitter' do
      token  = @authorization.send(:twitter_request_token).token
      secret = @authorization.send(:twitter_request_token).secret
      assert_equal [token, secret], @authorization.request_tokens
    end
  end

  def test_authorizing_with_twitter
    # Stub out since we can't authorize with Twitter
    access_token = OpenStruct.new token: '123', secret: '456'
    client       = OpenStruct.new authorize: true, authorized?: true
    @authorization.stubs(:build_oauth_access_token).returns access_token
    @authorization.stubs(:twitter_client).returns client

    @authorization.authorize_with_twitter 'abc', 'def', 'ghi'
    assert_equal '123', @authorization.oauth_token
    assert_equal '456', @authorization.oauth_token_secret
    assert @authorization.authorized?
  end

  def test_raise_exception_on_unauthorized_request
    assert_raise RuntimeError do
      @authorization.make_twitter_request :home_timeline
    end
  end

  def test_passing_options_with_twitter_requests
    fake_twitter_client = Class.new do
      def home_timeline(options={}); true; end
    end
    @authorization.stubs(:authorized?).returns true
    @authorization.stubs(:authorized_twitter_client).returns fake_twitter_client

    fake_twitter_client.expects(:home_timeline).with count: 5
    @authorization.make_twitter_request :home_timeline, count: 5
  end

end
