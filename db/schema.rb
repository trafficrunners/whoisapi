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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150807043358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "broken_domains", force: :cascade do |t|
    t.string   "url"
    t.text     "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains", force: :cascade do |t|
    t.string   "url"
    t.string   "tld"
    t.jsonb    "parts"
    t.jsonb    "server"
    t.jsonb    "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "domains", ["url"], name: "index_domains_on_url", using: :btree

  create_table "my_proxies", force: :cascade do |t|
    t.string  "ip"
    t.string  "port"
    t.string  "user"
    t.string  "pass"
    t.integer "timeout_errors",   default: 0
    t.integer "used",             default: 0
    t.integer "successful_whois"
  end

end
