class Option < ActiveRecord::Base
  attr_accessible :quantity, :strike, :expiry, :direction, :entered_at

end
