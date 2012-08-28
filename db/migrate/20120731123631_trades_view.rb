class TradesView < ActiveRecord::Migration
  def up
    common = [
      'id',
      'entry_date',
      'contract_period',
      'quantity',
      'buy_sell',
      'premium',
      'strike',
      'price',
      'currency',
      'option_type']
    projection = common.dup.append('version').append('user').append('lastUpdated').append('is_future').append('is_call').append('is_put')
    cols = common.dup.append('md5(concat(%s))' % common.map { |col|
      "coalesce(%s, '')" % [col]
    }.join(',')).append('user_id').append('updated_at').append(bool2yn('is_future')).append(bool2yn('is_call')).append(bool2yn('is_put'))
    execute 'create view trades_view (%s) as (select %s from trades)' % [
      projection.join(','),  cols.join(',')
    ]
  end

  def down
    execute 'drop view trades_view'
  end

  private

  def bool2yn(name)
    return "case when #{name} = 0 then 'N' else 'Y' end"
  end
end
