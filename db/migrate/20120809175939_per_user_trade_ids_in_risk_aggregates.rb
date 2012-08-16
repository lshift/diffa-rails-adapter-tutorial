class PerUserTradeIdsInRiskAggregates < ActiveRecord::Migration
  def up
    execute %q{alter view risks_view as select concat(trade_id, '') as id, expiry, coalesce(version, '') as version, user_id as user from futures union select concat(trade_id, '') as id, expiry, coalesce(version, '') as version, user_id as user from options order by id}
  end
end

