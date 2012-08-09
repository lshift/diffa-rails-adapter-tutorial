class Future < ActiveRecord::Base
  attr_accessible :quantity, :expiry, :price, :direction, :entered_at

  def as_json(options = {})
    super(options).merge(attributes: {})
  end
end
