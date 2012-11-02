class TradesEntryDateMonthly < ActiveRecord::Migration
  def up
    execute "create view trades_entry_date_monthly (user, entry_date, version) as (select user, date(date_format(entry_date, '%Y-%m-01')), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date(date_format(entry_date, '%Y-%m-01')))"
  end

  def down
    execute 'drop view trades_entry_date_monthly'
  end
end
