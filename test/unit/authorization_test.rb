require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
  def setup
    @kyle = users :kyle
    @authorization = @kyle.authorizations.create! username: 'kylewiest'
    callback_params = { 'oauth_token' => 'RGEfT1MVPC3tN3vFyBLyetRx1NDE98TLpWoDs2TOkM',
      'oauth_verifier' => 'oUT7GBCjtpVaUOK6ojttGeSbhjGLe2b8HKLkETuNok',
      'controller' => 'authorizations', 'action' => 'edit' }
  end

  # Validations
  should validate_presence_of(:user)
  should validate_presence_of(:username)

  # Associations
  should belong_to(:user)

  def test_building_an_oauth_request_token
    VCR.use_cassette 'twitter' do
      assert_equal OAuth::RequestToken, @authorization.send(:oauth_request_token).class,
        'Should be an OAuth::RequestToken'
    end
  end

end
