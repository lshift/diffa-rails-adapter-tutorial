class RisksView < ActiveRecord::Base
  self.table_name = :risks_view

  # I would love to know why I seemly have to do this. Reading the AR source 
  # code doesn't really help. 
  self.primary_key = :id

  def as_json(options = {})
    super(options).merge(attributes: {})
  end
end
