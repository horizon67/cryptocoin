class CreateRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories do |t|
      t.references :coin
      t.string :name
      t.string :language
      t.integer :pull_requests_count
      t.integer :contributors_count
      t.integer :watchers_count
      t.integer :stargazers_count
      t.integer :issues_count
      t.integer :commits_count_for_the_last_week
      t.integer :commits_count_for_the_last_month

      t.timestamps
    end
  end
end
