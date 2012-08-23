class TradesEntryDateMonthly < ActiveRecord::Migration
  def up
    execute "create view trades_entry_date_monthly (user, entry_date, version) as (select user, date_format(entry_date, '%Y-%m'), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date_format(entry_date, '%Y-%m'))"
  end

  def down
    execute 'drop view trades_entry_date_monthly'
  end
end
