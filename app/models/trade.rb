class Trade < ActiveRecord::Base
  attr_accessible :user_id, :ttype, :quantity, :expiry, :price, :direction, :entered_at
end
