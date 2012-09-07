require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create email: 'kyle@example.com', password: 'secret'
  end

  def sign_in(user)
    visit root_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Sign in'
  end

  def test_sign_in
    sign_in @user

    assert has_content?(@user.email), 'Displays current user email address'
    assert has_content?('sign out'), 'Has a link to sign out'
    refute has_css?('form#user-session'), 'Does not have session form'
  end

  def test_sign_out
    reset_session!
    sign_in @user
    click_link 'sign out'

    assert has_css?('form#user-session'), 'Should have form to sign in'
    refute has_content?(@user.email), 'Does not display current user email address'
    refute has_content?('sign out'), 'Does not have a link to sign out'
  end
end
