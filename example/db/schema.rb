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

ActiveRecord::Schema.define(:version => 20160305111014) do

  create_table "currencies", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name",       :null => false
    t.float    "rate",       :null => false
  end

  create_table "currencies_payment_gateways", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",        :null => false
    t.integer  "payment_gateway_id", :null => false
  end

  create_table "payment_gateways", :force => true do |t|
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "name",                                :null => false
    t.text     "image"
    t.string   "description"
    t.boolean  "branding",         :default => false, :null => false
    t.float    "rating",           :default => 0.0,   :null => false
    t.boolean  "setup_fee",        :default => false, :null => false
    t.string   "transaction_fees"
    t.string   "how_to_url"
  end

end
