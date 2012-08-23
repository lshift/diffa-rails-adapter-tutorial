class TradesEntryDateDaily < ActiveRecord::Base
  self.table_name = 'trades_entry_date_daily'
  self.primary_key = 'entry_date'

  def as_json(options = {})
    super(options).merge(attributes: { entry_date: entry_date })
  end
end

