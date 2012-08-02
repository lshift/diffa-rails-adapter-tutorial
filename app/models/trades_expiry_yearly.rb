class TradesExpiryYearly < ActiveRecord::Base
  self.table_name = 'trades_expiry_yearly'
  self.primary_key = 'expiry'

  def as_json(options = {})
    super(options).merge(attributes: { expiry: expiry })
  end
end

