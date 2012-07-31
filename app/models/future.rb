class Future < ActiveRecord::Base
  def as_json(options = {})
    super(options).merge(attributes: {})
  end
end
