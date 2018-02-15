class ChangeDatatypeCommitsCountOfRepositories < ActiveRecord::Migration[5.1]
  def change
    change_column :repositories, :commits_count, :integer
  end
end
