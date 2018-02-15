class CoinSerializer < ActiveModel::Serializer
  attributes :name, :symbol, :language, :pull_requests, :contributors, :watchers, :stargazers, :issues,
             :commits_for_the_last_week, :commits_for_the_last_month, :main_repository_url, :owner, :commits

  def name
    "#{object.name}(#{object.symbol})"
  end

  def language
    object.main_repository&.language
  end

  def pull_requests
    object.main_repository&.pull_requests_count
  end

  def contributors
    object.main_repository&.contributors_count
  end

  def watchers
    object.main_repository&.watchers_count
  end

  def stargazers
    object.main_repository&.stargazers_count
  end

  def issues
    object.main_repository&.issues_count
  end

  def commits
    object.main_repository&.commits_count
  end

  def commits_for_the_last_week
    object.main_repository&.commits_count_for_the_last_week
  end

  def commits_for_the_last_month
    object.main_repository&.commits_count_for_the_last_month
  end

  def main_repository_url
    object.main_repository_url
  end
end
