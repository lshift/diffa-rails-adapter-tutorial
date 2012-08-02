class TradesExpiryMonthly < ActiveRecord::Base
  self.table_name = 'trades_expiry_monthly'
  self.primary_key = 'expiry'

  def as_json(options = {})
    super(options).merge(attributes: { expiry: expiry })
  end
end

