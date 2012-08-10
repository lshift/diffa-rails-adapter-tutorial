class Option < ActiveRecord::Base
  attr_accessible :quantity, :strike, :expiry, :direction, :entered_at

  before_validation :assign_trade_id
  before_save :assign_version

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
    self.version = Digest::MD5.hexdigest(self.version) if changed? and not version_changed?
  end

  validates :trade_id, uniqueness: { :scope => :user_id }, presence: true
end
