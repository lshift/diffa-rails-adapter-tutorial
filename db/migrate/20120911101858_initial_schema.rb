class InitialSchema < ActiveRecord::Migration
  
  def up
  	
  	create_table :users do |t|
      t.string :auth_token,           null: false, default: ""

      t.timestamps
    end

    create_table :quote_names do |t|
      t.string :quote_name, null: false
    end
    
    add_index :quote_names, :quote_name, unique: true

    create_table :currencies do |t|
      t.string :currency,         null: false
    end
    
    add_index :currencies, :currency, unique: true

    create_table :option_types do |t|
      t.string :option_type,      null: false
    end
    
    add_index :option_types, :option_type, unique: true

    create_table :trades do |t|
      t.integer :user_id,         null: false
      t.datetime :entry_date,     null: false
      t.string :contract_period,  null: false
      t.integer :quantity,        null: false
      t.string :buy_sell,         null: false
      t.boolean :is_future,       null: false
      t.boolean :is_call,         null: false
      t.boolean :is_put,          null: false
      t.decimal :premium,         null: true
      t.decimal :strike,          null: true
      t.decimal :price,           null: true
      t.string :currency,         null: false
      t.string :option_type,      null: false
      t.string :symbol,           null: false
      t.timestamps
    end
    
    add_foreign_key(:trades, :currencies, {
      name: :trade_currency_fk,
      column: :currency,
      primary_key: :currency
    })
    
    add_foreign_key(:trades, :users, {
      name: :trade_user_fk,
      column: :user_id
    })
    
    add_foreign_key(:trades, :quote_names, {
      name: :trade_quote_fk,
      column: :symbol,
      primary_key: :quote_name      
    })

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
      'symbol',
      'option_type']
    
    projection = common.dup.append('version').append('user').append('lastUpdated').append('is_future').append('is_call').append('is_put')
    
    cols = common.dup.append('md5(concat(%s))' % common.map { |col|
      "coalesce(%s, '')" % [col]
    }.join(',')).append('user_id').append('updated_at').append(bool2yn('is_future')).append(bool2yn('is_call')).append(bool2yn('is_put'))
    
    execute 'create view trades_view (%s) as (select %s from trades)' % [
      projection.join(','),  cols.join(',')
    ]

    create_table :options do |t|
      t.integer :user_id,         null: false
      t.integer :trade_id,         null: false
      t.datetime :trade_date,      null: false
      t.string :version,          null: true
      t.integer :lots,            null: false
      t.decimal :premium_price,   null: false
      t.decimal :strike_price,    null: false
      t.string :exercise_right,   null: false
      t.string :exercise_type,    null: false
      t.string :quote,            null: false
      t.string :year,             null: false
      t.string :month,            null: false

      t.timestamps
    end
    
    add_foreign_key(:options, :quote_names, {
      name: :option_quote_fk,
      column: :quote,
      primary_key: :quote_name
    })
    
    add_foreign_key(:options, :users, {
      name: :option_user_fk,
      column: :user_id
    })

    create_table :futures do |t|
      t.integer :user_id,         null: false
      t.integer :trade_id,        null: false
      t.datetime :trade_date,     null: false
      t.string :version,          null: true
      t.integer :lots,            null: false
      t.decimal :entry_price,     null: false
      t.string :quote,            null: false
      t.string :year,             null: false
      t.string :month,            null: false

      t.timestamps
    end
    
    add_foreign_key(:futures, :quote_names, {
      name: :future_quote_fk,
      column: :quote,
      primary_key: :quote_name
    })
    
    add_foreign_key(:futures, :users, {
      name: :future_user_fk,
      column: :user_id
    })

    execute %q{create view risks_view (id, trade_date, type_code, version, user) as select trade_id, trade_date, 'F', coalesce(version, ''), user_id from futures union select trade_id, trade_date, 'O', coalesce(version, ''), user_id from options order by id, type_code}

    execute "create view risks_trade_date_yearly (user, trade_date, version) as (select user, date_format(trade_date, '%Y'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(trade_date, '%Y'))"
    execute "create view risks_trade_date_monthly (user, trade_date, version) as (select user, date_format(trade_date, '%Y-%m'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(trade_date, '%Y-%m'))"
    execute "create view risks_trade_date_daily (user, trade_date, version) as (select user, date_format(trade_date, '%Y-%m-%d'), md5(group_concat(version order by id asc separator '')) from risks_view group by user, date_format(trade_date, '%Y-%m-%d'))"

    execute "create view trades_entry_date_yearly (user, entry_date, version) as (select user, date_format(entry_date, '%Y'), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date_format(entry_date, '%Y'))"
    execute "create view trades_entry_date_monthly (user, entry_date, version) as (select user, date_format(entry_date, '%Y-%m'), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date_format(entry_date, '%Y-%m'))"
    execute "create view trades_entry_date_daily (user, entry_date, version) as (select user, date_format(entry_date, '%Y-%m-%d'), md5(group_concat(version order by id asc separator '')) from trades_view group by user, date_format(entry_date, '%Y-%m-%d'))"

  end

  def down

    execute 'drop view trades_entry_date_daily'
    execute 'drop view trades_entry_date_monthly'
    execute 'drop view trades_entry_date_yearly'

    execute 'drop view risks_trade_date_yearly'
    execute 'drop view risks_trade_date_monthly'
    execute 'drop view risks_trade_date_daily'
    execute 'drop view risks_view'
  	execute 'drop view trades_view'
  	
    drop_table :futures
    drop_table :options
    drop_table :trades
  	drop_table :option_types
  	drop_table :currencies
    drop_table :quote_names
  	drop_table :users  	
  end

  private

  def bool2yn(name)
    return "case when #{name} = 0 then 'N' else 'Y' end"
  end

end
