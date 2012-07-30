class CreateFutures < ActiveRecord::Migration
  def change
    create_table :futures do |t|
      t.integer :user_id
      t.integer :quantity
      t.date :expiry
      t.decimal :price
      t.string :direction
      t.date :entered_at
      t.string :version

      t.timestamps
    end
  end
end
