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

ActiveRecord::Schema.define(version: 20180307160004) do

  create_table "arbitrage_btcs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "best_ask_price"
    t.integer "best_bid_price"
    t.string "best_ask_exchange"
    t.string "best_bid_exchange"
    t.integer "arbitrage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "btc_jpies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "last"
    t.integer "bid"
    t.integer "ask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "btc_usds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "last"
    t.integer "bid"
    t.integer "ask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "symbol"
    t.string "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repositories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "coin_id"
    t.string "name"
    t.string "language"
    t.integer "pull_requests_count"
    t.integer "contributors_count"
    t.integer "watchers_count"
    t.integer "stargazers_count"
    t.integer "issues_count"
    t.integer "commits_count_for_the_last_week"
    t.integer "commits_count_for_the_last_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commits_count"
    t.index ["coin_id"], name: "index_repositories_on_coin_id"
  end

end
