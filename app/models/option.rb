class Option < ActiveRecord::Base
  attr_accessible :quantity, :strike, :expiry, :direction, :entered_at

  validates :trade_id, uniqueness: { :scope => :user_id }, presence: true
end
