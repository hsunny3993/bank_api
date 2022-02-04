class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :customer, index: true, foreign_key: true
      t.column :account_id,           :integer, null: false
      t.column :debit_credit_flag,    :boolean
      t.column :amount,               :numeric
      t.column :transaction_date,     :datetime, null: false
      t.timestamps
    end
  end
end
