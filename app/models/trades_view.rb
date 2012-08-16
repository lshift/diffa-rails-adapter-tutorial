class TradesView < ActiveRecord::Base
  self.table_name = 'trades_view'
  self.primary_key = 'id'

  def as_json(options = {})
    super(options).merge(attributes: {})
  end
end

