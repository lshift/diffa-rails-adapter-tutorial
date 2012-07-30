class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.integer :user_id
      t.integer :quantity
      t.decimal :strike
      t.date :expiry
      t.string :direction
      t.date :entered_at
      t.string :version

      t.timestamps
    end
  end
end
