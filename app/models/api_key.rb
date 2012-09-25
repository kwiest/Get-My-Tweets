class ApiKey < ActiveRecord::Base
  attr_accessible :user_id, :remote_uri
  belongs_to :user

  validates :user, presence: true
  validates :remote_uri, presence: true

  before_validation :generate_key


  private

  def generate_key
    begin
      self.key = SecureRandom.hex
    end while self.class.exists? key: key
  end
end
