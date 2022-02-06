class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, allow_blank: false, uniqueness: true
end
