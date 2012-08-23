class CreateQuoteNames < ActiveRecord::Migration
  def change
    create_table :quote_names do |t|
      t.string :quote_name, null: false
    end
    add_index :quote_names, :quote_name, unique: true
  end
end

