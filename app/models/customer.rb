class Customer < ApplicationRecord
  has_one :account
  has_many :transactions, dependent: :destroy

  validates :email, :phone, presence: true, allow_blank: false, uniqueness: true
end
