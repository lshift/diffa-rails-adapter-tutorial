class CreateTrades < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :currency,         null: false
    end
    add_index :currencies, :currency, unique: true

    create_table :option_types do |t|
      t.string :option_type,      null: false
    end
    add_index :option_types, :option_type, unique: true

    create_table :trades do |t|
      t.integer :user_id,         null: false
      t.datetime :entry_date,     null: false
      t.string :contract_period,  null: false
      t.integer :quantity,        null: false
      t.string :buy_sell,         null: false
      t.boolean :is_future,       null: false
      t.boolean :is_call,         null: false
      t.boolean :is_put,          null: false
      t.decimal :premium,         null: true
      t.decimal :strike,          null: true
      t.decimal :price,           null: true
      t.string :currency,         null: false
      t.string :option_type,      null: false
      t.timestamps
    end
    add_foreign_key(:trades, :currencies, {
      name: :trade_currency_fk,
      column: :currency,
      primary_key: :currency
    })
    add_foreign_key(:trades, :users, {
      name: :trade_user_fk,
      column: :user_id
    })
  end
end
