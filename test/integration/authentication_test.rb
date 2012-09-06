require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  def test_sign_in
    user = User.create(email: 'me@example.com', password: 'secret')

    visit root_path

    fill_in 'email', with: 'me@example.com'
    fill_in 'password', with: 'secret'
    click_button 'Sign in'

    assert contains?('Signed in!')
  end
end
