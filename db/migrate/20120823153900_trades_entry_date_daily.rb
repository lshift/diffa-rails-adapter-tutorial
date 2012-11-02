class TradesEntryDateDaily < ActiveRecord::Migration
  def up
    execute "create view trades_entry_date_daily (user, entry_date, version) as (select user, date(date_format(entry_date, '%Y-%m-%d')), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date(date_format(entry_date, '%Y-%m-%d')))"
  end

  def down
    execute 'drop view trades_entry_date_daily'
  end
end
