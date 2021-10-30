class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.decimal :usdt_value, null: false
      t.decimal :exchange_rate, null: false
      t.decimal :exchange_fee, null: false
      t.string :tx_id, null: false
      t.string :address, null: false
      t.string :email, null: false
      t.boolean :success, default: false, null: false

      t.timestamps
    end
  end
end
