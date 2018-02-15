class AddCommitsCountToRepositories < ActiveRecord::Migration[5.1]
  def change
    add_column :repositories, :commits_count, :string
  end
end
