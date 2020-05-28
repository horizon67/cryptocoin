class AddAddForeignKeyToRepositories < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :repositories, :coins
  end
end
