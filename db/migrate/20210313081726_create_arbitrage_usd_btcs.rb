class CreateArbitrageUsdBtcs < ActiveRecord::Migration[5.2]
  def change
    create_table :arbitrage_usd_btcs do |t|
      t.float :best_ask_price
      t.float :best_bid_price
      t.string :best_ask_exchange
      t.string :best_bid_exchange
      t.float :arbitrage

      t.timestamps
    end
  end
end
