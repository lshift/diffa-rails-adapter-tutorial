class TradesExpiryMonthly < ActiveRecord::Migration
  def up
    execute "create view trades_expiry_monthly (user, expiry, version) as (select user, date_format(expiry, '%Y-%m'), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date_format(expiry, '%Y-%m'))"
  end

  def down
    execute 'drop view trades_expiry_monthly'
  end
end
