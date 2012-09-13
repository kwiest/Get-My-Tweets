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

end
