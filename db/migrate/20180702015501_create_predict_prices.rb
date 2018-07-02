class CreatePredictPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :predict_prices do |t|
      t.integer :last_price
      t.integer :price
      t.string :candle_term

      t.timestamps
    end
  end
end
