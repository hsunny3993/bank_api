class Account < ApplicationRecord
  belongs_to :customer
  validates :account_number, presence: true, allow_blank: false, uniqueness: true

  def self.credit(account_number, amount)
    @account = find_by_account_number(account_number)
    current_balance = @account.account_balance
    new_balance = current_balance + amount

    @account.update(account_balance: new_balance)

    @account
  end

  def self.debit(account_number, amount)
    @account = find_by_account_number(account_number)
    current_balance = @account.account_balance
    new_balance = current_balance - amount

    @account.update(account_balance: new_balance)

    @account
  end

  def self.generate_account_number
    charset = Array('0'..'9')
    Array.new(12) { charset.sample }.join
  end
end
