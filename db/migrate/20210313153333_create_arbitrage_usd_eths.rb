class CreateArbitrageUsdEths < ActiveRecord::Migration[5.2]
  def change
    create_table :arbitrage_usd_eths do |t|
      t.integer :best_ask_price
      t.integer :best_bid_price
      t.string :best_ask_exchange
      t.string :best_bid_exchange
      t.integer :arbitrage

      t.timestamps
    end
  end
end
