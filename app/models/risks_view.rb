class RisksView < ActiveRecord::Base
  self.table_name = :risks_view

  def as_json(options = {})
    super(options).merge(attributes: {})
  end
end
