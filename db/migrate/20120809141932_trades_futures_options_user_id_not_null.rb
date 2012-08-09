class TradesFuturesOptionsUserIdNotNull < ActiveRecord::Migration
  def change
    change_column :trades, :user_id, :integer, :null => false, :default => 1
    change_column :futures, :user_id, :integer, :null => false, :default => 1
    change_column :options, :user_id, :integer, :null => false, :default => 1
  end
end
