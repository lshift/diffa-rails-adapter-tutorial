class CreateFutures < ActiveRecord::Migration
  def change
    create_table :futures do |t|
      t.integer :user_id,         null: false
      t.integer :trade_id,        null: false
      t.datetime :trade_date,     null: false
      t.string :version,          null: true
      t.integer :lots,            null: false
      t.decimal :entry_price,     null: false
      t.string :quote,            null: false
      t.string :year,             null: false
      t.string :month,            null: false

      t.timestamps
    end
    add_foreign_key(:futures, :quote_names, {
      name: :future_quote_fk,
      column: :quote,
      primary_key: :quote_name
    })
    add_foreign_key(:futures, :users, {
      name: :future_user_fk,
      column: :user_id
    })
  end
end

