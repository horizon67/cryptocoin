class CreateBtcUsds < ActiveRecord::Migration[5.1]
  def change
    create_table :btc_usds do |t|
      t.integer :last
      t.integer :bid
      t.integer :ask

      t.timestamps
    end
  end
end
