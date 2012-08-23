class RiskAggregates < ActiveRecord::Migration
  def up
    execute %q{create view risks_view (id, trade_date, version, user) as select trade_id, trade_date, coalesce(version, ''), user_id from futures union select trade_id, trade_date, coalesce(version, ''), user_id from options order by id}

    execute "create view risks_trade_date_yearly (user, trade_date, version) as (select user, date_format(trade_date, '%Y'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(trade_date, '%Y'))"
    execute "create view risks_trade_date_monthly (user, trade_date, version) as (select user, date_format(trade_date, '%Y-%m'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(trade_date, '%Y-%m'))"
    execute "create view risks_trade_date_daily (user, trade_date, version) as (select user, date_format(trade_date, '%Y-%m-%d'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(trade_date, '%Y-%m-%d'))"
  end

  def down
    execute 'drop view risks_trade_date_yearly'
    execute 'drop view risks_trade_date_monthly'
    execute 'drop view risks_trade_date_daily'
    execute 'drop view risks_view'
  end
end

