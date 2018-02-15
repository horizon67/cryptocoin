class CreateBtcJpies < ActiveRecord::Migration[5.1]
  def change
    create_table :btc_jpies do |t|
      t.integer :last
      t.integer :bid
      t.integer :ask

      t.timestamps
    end
  end
end
