class TradesEntryDateYearly < ActiveRecord::Migration
  def up
    execute "create view trades_entry_date_yearly (user, entry_date, version) as (select user, date(date_format(entry_date, '%Y-01-01')), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date(date_format(entry_date, '%Y-01-01')))"
  end

  def down
    execute 'drop view trades_entry_date_yearly'
  end
end
