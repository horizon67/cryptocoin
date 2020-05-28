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

ActiveRecord::Schema.define(version: 2020_05_20_135658) do

  create_table "arbitrage_btcs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "best_ask_price"
    t.integer "best_bid_price"
    t.string "best_ask_exchange"
    t.string "best_bid_exchange"
    t.integer "arbitrage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "btc_jpies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "last"
    t.integer "bid"
    t.integer "ask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "btc_usds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "last"
    t.integer "bid"
    t.integer "ask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.string "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "predict_prices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "last_price"
    t.integer "price"
    t.string "candle_term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repositories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  add_foreign_key "repositories", "coins"
end
