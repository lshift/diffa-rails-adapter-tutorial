class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :user_id
      t.string :ttype
      t.integer :quantity
      t.date :expiry
      t.decimal :price
      t.string :direction
      t.date :entered_at

      t.timestamps
    end
  end
end
