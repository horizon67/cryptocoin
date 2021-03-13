# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_13_153333) do

  create_table "arbitrage_btcs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "best_ask_price"
    t.integer "best_bid_price"
    t.string "best_ask_exchange"
    t.string "best_bid_exchange"
    t.integer "arbitrage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "arbitrage_usd_btcs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "best_ask_price"
    t.float "best_bid_price"
    t.string "best_ask_exchange"
    t.string "best_bid_exchange"
    t.float "arbitrage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "arbitrage_usd_eths", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "best_ask_price"
    t.integer "best_bid_price"
    t.string "best_ask_exchange"
    t.string "best_bid_exchange"
    t.integer "arbitrage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "btc_jpies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "last"
    t.integer "bid"
    t.integer "ask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "btc_usds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "last"
    t.integer "bid"
    t.integer "ask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.string "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "predict_prices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "last_price"
    t.integer "price"
    t.string "candle_term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repositories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  add_foreign_key "repositories", "coins"
end
