class TradesExpiryDaily < ActiveRecord::Migration
  def up
    execute "create view trades_expiry_daily (user, expiry, version) as (select user, date_format(expiry, '%Y-%m-%d'), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date_format(expiry, '%Y-%m-%d'))"
  end

  def down
    execute 'drop view trades_expiry_daily'
  end
end
