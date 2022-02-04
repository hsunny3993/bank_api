class Customer < ApplicationRecord
  has_one :account
  has_many :transactions, dependent: :destroy
end
