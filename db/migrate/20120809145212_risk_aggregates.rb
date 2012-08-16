class RiskAggregates < ActiveRecord::Migration
  def up
    execute %q{create view risks_view as select concat(id, '') as id, expiry, coalesce(version, '') as version, user_id as user from futures union select concat(id, ''), expiry, coalesce(version, '') as version, user_id as user from options order by id}

    execute "create view risks_expiry_yearly (user, expiry, version) as (select user, date_format(expiry, '%Y'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(expiry, '%Y'))"
    execute "create view risks_expiry_monthly (user, expiry, version) as (select user, date_format(expiry, '%Y-%m'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(expiry, '%Y-%m'))"
    execute "create view risks_expiry_daily (user, expiry, version) as (select user, date_format(expiry, '%Y-%m-%d'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(expiry, '%Y-%m-%d'))"
  end

  def down
    execute 'drop view risks_expiry_yearly'
    execute 'drop view risks_expiry_monthly'
    execute 'drop view risks_expiry_daily'
    execute 'drop view risks_view'
  end
end

