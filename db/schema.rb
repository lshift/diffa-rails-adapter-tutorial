# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120823153900) do

  create_table "currencies", :force => true do |t|
    t.string "currency", :null => false
  end

  add_index "currencies", ["currency"], :name => "index_currencies_on_currency", :unique => true

  create_table "futures", :force => true do |t|
    t.integer  "user_id",                                    :null => false
    t.string   "trade_id",                                   :null => false
    t.datetime "trade_date",                                 :null => false
    t.string   "version"
    t.integer  "lots",                                       :null => false
    t.decimal  "entry_price", :precision => 10, :scale => 0, :null => false
    t.string   "quote",                                      :null => false
    t.string   "year",                                       :null => false
    t.string   "month",                                      :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "futures", ["quote"], :name => "future_quote_fk"
  add_index "futures", ["user_id"], :name => "future_user_fk"

  create_table "option_types", :force => true do |t|
    t.string "option_type", :null => false
  end

  add_index "option_types", ["option_type"], :name => "index_option_types_on_option_type", :unique => true

  create_table "options", :force => true do |t|
    t.integer  "user_id",                                       :null => false
    t.string   "trade_id",                                      :null => false
    t.datetime "trade_date",                                    :null => false
    t.string   "version"
    t.integer  "lots",                                          :null => false
    t.decimal  "premium_price",  :precision => 10, :scale => 0, :null => false
    t.string   "exercise_right",                                :null => false
    t.string   "exercise_type",                                 :null => false
    t.string   "quote",                                         :null => false
    t.string   "year",                                          :null => false
    t.string   "month",                                         :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "options", ["quote"], :name => "option_quote_fk"
  add_index "options", ["user_id"], :name => "option_user_fk"

  create_table "quote_names", :force => true do |t|
    t.string "quote_name", :null => false
  end

  add_index "quote_names", ["quote_name"], :name => "index_quote_names_on_quote_name", :unique => true

  create_table "risks_trade_date_daily", :id => false, :force => true do |t|
    t.integer "user",                     :default => 0, :null => false
    t.string  "trade_date", :limit => 10
    t.string  "version",    :limit => 32
  end

  create_table "risks_trade_date_monthly", :id => false, :force => true do |t|
    t.integer "user",                     :default => 0, :null => false
    t.string  "trade_date", :limit => 7
    t.string  "version",    :limit => 32
  end

  create_table "risks_trade_date_yearly", :id => false, :force => true do |t|
    t.integer "user",                     :default => 0, :null => false
    t.string  "trade_date", :limit => 4
    t.string  "version",    :limit => 32
  end

  create_table "risks_view", :id => false, :force => true do |t|
    t.string   "id",         :default => "", :null => false
    t.datetime "trade_date",                 :null => false
    t.string   "version"
    t.integer  "user",       :default => 0,  :null => false
  end

  create_table "trades", :force => true do |t|
    t.integer  "user_id",                                        :null => false
    t.datetime "entry_date",                                     :null => false
    t.datetime "expiry",                                         :null => false
    t.string   "contract_period",                                :null => false
    t.integer  "quantity",                                       :null => false
    t.string   "buy_sell",                                       :null => false
    t.boolean  "is_future",                                      :null => false
    t.boolean  "is_call",                                        :null => false
    t.boolean  "is_put",                                         :null => false
    t.decimal  "premium",         :precision => 10, :scale => 0
    t.decimal  "strike",          :precision => 10, :scale => 0
    t.decimal  "price",           :precision => 10, :scale => 0
    t.string   "currency",                                       :null => false
    t.string   "option_type",                                    :null => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "trades", ["currency"], :name => "trade_currency_fk"
  add_index "trades", ["user_id"], :name => "trade_user_fk"

  create_table "trades_entry_date_daily", :id => false, :force => true do |t|
    t.integer "user",                     :null => false
    t.string  "entry_date", :limit => 10
    t.string  "version",    :limit => 32
  end

  create_table "trades_entry_date_monthly", :id => false, :force => true do |t|
    t.integer "user",                     :null => false
    t.string  "entry_date", :limit => 7
    t.string  "version",    :limit => 32
  end

  create_table "trades_entry_date_yearly", :id => false, :force => true do |t|
    t.integer "user",                     :null => false
    t.string  "entry_date", :limit => 4
    t.string  "version",    :limit => 32
  end

  create_table "trades_view", :id => false, :force => true do |t|
    t.integer  "id",                                                           :default => 0,  :null => false
    t.datetime "entry_date",                                                                   :null => false
    t.datetime "expiry",                                                                       :null => false
    t.string   "contract_period",                                                              :null => false
    t.integer  "quantity",                                                                     :null => false
    t.string   "buy_sell",                                                                     :null => false
    t.decimal  "premium",                       :precision => 10, :scale => 0
    t.decimal  "strike",                        :precision => 10, :scale => 0
    t.decimal  "price",                         :precision => 10, :scale => 0
    t.string   "currency",                                                                     :null => false
    t.string   "option_type",                                                                  :null => false
    t.string   "version",         :limit => 32
    t.integer  "user",                                                                         :null => false
    t.datetime "lastUpdated",                                                                  :null => false
    t.string   "is_future",       :limit => 1,                                 :default => "", :null => false
    t.string   "is_call",         :limit => 1,                                 :default => "", :null => false
    t.string   "is_put",          :limit => 1,                                 :default => "", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "auth_token", :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_foreign_key "futures", "quote_names", :name => "future_quote_fk", :column => "quote", :primary_key => "quote_name"
  add_foreign_key "futures", "users", :name => "future_user_fk"

  add_foreign_key "options", "quote_names", :name => "option_quote_fk", :column => "quote", :primary_key => "quote_name"
  add_foreign_key "options", "users", :name => "option_user_fk"

  add_foreign_key "trades", "currencies", :name => "trade_currency_fk", :column => "currency", :primary_key => "currency"
  add_foreign_key "trades", "users", :name => "trade_user_fk"

end
