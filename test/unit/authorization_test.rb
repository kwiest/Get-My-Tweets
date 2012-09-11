require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
  def setup
    @kyle = users :kyle
  end

  # Validations
  should validate_presence_of(:user)
  should validate_presence_of(:username)

  # Associations
  should belong_to(:user)

  def test_oauth_token_assigned_on_create
    VCR.use_cassette 'twitter' do
      authorization = @kyle.authorizations.create! username: 'kylewiest'
      refute authorization.oauth_token.nil?
      refute authorization.oauth_token_secret.nil?
    end
  end
end
