class Future < ActiveRecord::Base
  attr_accessible :quantity, :trade_id, :user_id, :trade_date, :lots, :entry_price, :quote, :year, :month

  validates :trade_id, uniqueness: { :scope => :user_id }, presence: true


  before_validation :assign_trade_id
  before_save :assign_version
  before_save :add_defaults

  def assign_trade_id
    pp attributes: attributes
    return unless self.trade_id.nil? or trade_id == 0
    futures = self.class.arel_table
    q = futures.project(futures[:trade_id].maximum).
      where(futures[:user_id].eq(user_id)).
      group(futures[:user_id])
    last_id, = connection.execute(q.to_sql).first
    self.trade_id = (last_id.to_i || 0) + 1
    pp trade_id: trade_id, last_id: last_id
  end


  def add_defaults
    self.entry_price ||= 2
    self.lots ||= 1
    self.trade_date = Time.now.utc
    contract_period = self.trade_date + 3.months
    self.month ||= contract_period.month
    self.year ||= contract_period.year
    self.quote ||= QuoteName.all.shuffle.first.quote_name
  end

  # TODO: Upstream versions?
  def assign_version
    self.version = Digest::MD5.hexdigest(self.version || '') if changed? and not version_changed?
  end

  def as_json(options = {})
    super(options).merge(attributes: {})
  end


  def self.create_or_update_from_trade(t)
    instrument = find_by_trade_id(t.id) || new

    instrument.trade_id = t.id
    instrument.user_id = t.user
    instrument.version = t.version

    mm, yy = t.contract_period.split('/', 2).map(&:to_i)

    instrument.update_attributes(trade_date: t.entry_date, lots: t.quantity,
                                 entry_price: t.price, quote: t.symbol,
                                 year: yy, month: mm)

    ActiveRecord::Base.transaction do 
      instrument.save!
      Option.where(:trade_id => t.id).delete_all
    end

  end

end
