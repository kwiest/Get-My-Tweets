require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase
  # Validations
  # key is being set before validations
  # should validate_presence_of(:key)
  # should validate_uniqueness_of(:key)
  should validate_presence_of(:user)

  # Associations
  should belong_to(:user)

  def test_generate_key_on_create
    kyle = users :kyle
    api_key = kyle.api_keys.create!

    refute api_key.key.nil?
  end
end
