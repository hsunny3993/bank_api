class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.column :name,  :string, null: false
      t.column :email, :string, null: false, index: { unique: true }
      t.column :phone, :string, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
