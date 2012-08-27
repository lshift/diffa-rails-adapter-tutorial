class Trade < ActiveRecord::Base
  attr_accessible :user_id, :entry_date, :contract_period, :quantity, :buy_sell, :is_future, :is_call, :is_put, :premium, :strike, :price, :currency, :option_type, :expiry


  before_create :set_defaults

  def set_defaults
    self.contract_period ||= '01/03'
    self.buy_sell ||= 'B'
    self.is_future ||= false
    self.is_call ||= false
    self.is_put ||= false
    self.currency ||= 'EUR'
    self.option_type ||= 'ETO'
    self.entry_date ||= Time.now.utc
    self.expiry ||= self.entry_date + 1.days
  end
end
