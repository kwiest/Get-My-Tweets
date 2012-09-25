require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase
  # Validations
  # key is being set before validations
  # should validate_presence_of(:key)
  # should validate_uniqueness_of(:key)
  should validate_presence_of :user
  should validate_presence_of :remote_uri

  # Associations
  should belong_to :user

  def test_generate_key_on_create
    kyle = users :kyle
    api_key = kyle.api_keys.create! remote_uri: 'http://example.com'

    refute api_key.key.nil?
  end
end
