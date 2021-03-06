class User < ActiveRecord::Base
  attr_accessible :email, :password
  has_many :api_keys
  has_many :authorizations
  has_secure_password

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, on: :create
end
