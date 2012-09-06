class User < ActiveRecord::Base
  attr_accessible :email, :password_hash, :password_salt
  has_secure_password

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, on: :create
end
