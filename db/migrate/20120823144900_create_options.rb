class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer :user_id,         null: false
      t.integer :trade_id,         null: false
      t.datetime :trade_date,      null: false
      t.string :version,          null: true
      t.integer :lots,            null: false
      t.decimal :premium_price,   null: false
      t.decimal :strike_price,    null: false
      t.string :exercise_right,   null: false
      t.string :exercise_type,    null: false
      t.string :quote,            null: false
      t.string :year,             null: false
      t.string :month,            null: false

      t.timestamps
    end
    add_foreign_key(:options, :quote_names, {
      name: :option_quote_fk,
      column: :quote,
      primary_key: :quote_name
    })
    add_foreign_key(:options, :users, {
      name: :option_user_fk,
      column: :user_id
    })
  end
end

