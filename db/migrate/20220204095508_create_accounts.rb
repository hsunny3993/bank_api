class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.belongs_to :customer, index: { unique: true }, foreign_key: true
      t.column :account_name,     :string, null: false, default: ''
      t.column :account_number,   :string, null: false, index: { unique: true }
      t.column :account_balance,  :numeric, null: false, default: 0
      t.timestamps
    end
  end
end
