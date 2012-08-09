class AddTradeIdToOptionsFutures < ActiveRecord::Migration
  def change
    add_column :futures, :trade_id, :integer, :null => false, :default => 0
    add_column :options, :trade_id, :integer, :null => false, :default => 0
  end
end
