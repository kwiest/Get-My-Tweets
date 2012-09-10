require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Validations
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)
  should validate_presence_of(:password)

  # Associations
  should have_many(:api_keys)
end
