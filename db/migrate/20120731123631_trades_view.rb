class TradesView < ActiveRecord::Migration
  def up
    common = [
      'id',
      'ttype',
      'quantity',
      'expiry',
      'price',
      'direction',
      'entered_at']
    projection = common.dup.append('version').append('user')
    cols = common.dup.append('md5(%s)' % common.join('||')).append('user_id')
    execute 'create view trades_view (%s) as (select %s from trades)' % [
      projection.join(','),  cols.join(',')
    ]
  end

  def down
    execute 'drop view trades_view'
  end
end
