class CreateArbitrageBtcs < ActiveRecord::Migration[5.1]
  def change
    create_table :arbitrage_btcs do |t|
      t.integer :best_ask_price
      t.integer :best_bid_price
      t.string :best_ask_exchange
      t.string :best_bid_exchange
      t.integer :arbitrage

      t.timestamps
    end
  end
end
