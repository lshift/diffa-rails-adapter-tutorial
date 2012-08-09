class Future < ActiveRecord::Base
  attr_accessible :quantity, :expiry, :price, :direction, :entered_at

  validates :trade_id, uniqueness: { :scope => :user_id }, presence: true

  def as_json(options = {})
    super(options).merge(attributes: {})
  end
end
