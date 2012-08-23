class Trade < ActiveRecord::Base
  attr_accessible :user_id, :entry_date, :contract_period, :quantity, :buy_sell, :is_future, :is_call, :is_put, :premium, :strike, :price, :currency, :option_type
end
