class Option < ActiveRecord::Base
  attr_accessible :quantity, :user_id, :trade_date, :lots, :premium_price, :strike_price, :exercise_right, :exercise_type, :quote, :year, :month

  before_validation :assign_trade_id
  before_save :assign_version

  before_create :add_defaults

  def assign_trade_id
    pp attributes: attributes
    return unless self.trade_id.nil? or trade_id == 0
    options = self.class.arel_table
    q = options.project(options[:trade_id].maximum).
      where(options[:user_id].eq(user_id)).
      group(options[:user_id])
    last_id, = connection.execute(q.to_sql).first
    self.trade_id = (last_id || 0) + 1
    pp trade_id: trade_id, last_id: last_id
  end

  # TODO: Upstream versions?
  def assign_version
    self.version = Digest::MD5.hexdigest(self.version || '') if changed? and not version_changed?
  end


  def add_defaults
    self.exercise_right ||= 'CALL'
    self.exercise_type ||= 'American'
    self.lots ||= 1
    self.trade_date = Time.now.utc
    contract_period = self.trade_date + 3.months
    self.month ||= contract_period.month
    self.year ||= contract_period.year
    self.strike_price ||= rand * 100
    self.premium_price ||= self.strike_price * (0.05 + (rand * 0.05))
    self.quote ||= QuoteName.all.shuffle.first.quote_name
  end

  validates :trade_id, uniqueness: { :scope => :user_id }, presence: true


  def self.create_or_update_from_trade(t)
    instrument = find_by_trade_id(t.id) || new
    
    instrument.trade_id = t.id
    instrument.user_id = t.user
    instrument.version = t.version

# TODO: Add symbol / quote field to trades.
    mm, yy = t.contract_period.split('/', 2).map(&:to_i)
    instrument.update_attributes(trade_date: t.entry_date,
                                 strike_price: t.price, exercise_right: t.is_call ? 'CALL' : 'PUT',
                                 lots: t.quantity, premium_price: t.premium,
                                 exercise_type: 'American', quote: t.symbol,
                                 year: yy, month: mm)


    pp trade_attrs: t.attributes, new_option_attrs: instrument.attributes
    ActiveRecord::Base.transaction do 
      instrument.save!
      Future.where(:trade_id => t.id).delete_all
    end
  end
end
