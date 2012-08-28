class Trade < ActiveRecord::Base
  attr_accessible :user_id, :entry_date, :contract_period, :quantity, :buy_sell, :is_future, :is_call, :is_put, :premium, :strike, :price, :currency, :option_type


  before_save :set_defaults

  def set_defaults
    self.buy_sell ||= 'B'
    self.is_future ||= false
    self.is_call ||= false
    self.is_put ||= false
    self.currency ||= 'EUR'
    self.option_type ||= 'ETO'
    self.entry_date ||= Time.now.utc
    self.contract_period ||= (self.entry_date + 2.months).strftime('%m/%Y')
    self.premium ||= self.price * (0.05 + (rand * 0.05))
    self.symbol ||= 'NYMEX WTI'
  end
end
