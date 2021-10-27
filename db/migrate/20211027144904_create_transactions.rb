class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.decimal :usdt_value, null: false
      t.decimal :btc_value, null: false
      t.string :uid, null: false
      t.string :address, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
