require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest
  def test_creating_user
    visit root_path
    click_link 'Create an account'

    fill_in 'user[email]', with: 'test@example.com'
    fill_in 'user[password]', with: 'secret'
    click_button 'Create account'

    assert has_content?('test@example.com'), 'Should show user email address'
    assert has_content?('sign out'), 'Has a link to sign out'
  end

  def test_deleting_user

  end
end
