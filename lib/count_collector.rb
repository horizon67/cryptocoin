class CountCollector
  REPOSITORY_API_URL_BASE = "https://api.github.com".freeze
  REPOSITORY_URL_BASE = "https://github.com".freeze
  attr_accessor :commits_count_for_the_last_week,
                :commits_count_for_the_last_month,
                :stargazers_count,
                :watchers_count,
                :language,
                :pull_requests_count,
                :contributors_count,
                :issues_count,
                :commits_count

  def initialize(repository)
    @repository = repository
    @connection = connection
  end

  def execute!
    set_commit_activity
    set_language
    set_contributors_count
    scraping

    # db update
    @repository.update!(language: @language, pull_requests_count: @pull_requests_count, contributors_count: @contributors_count,
                        watchers_count: @watchers_count, stargazers_count: @stargazers_count, commits_count_for_the_last_week: @commits_count_for_the_last_week,
                        commits_count_for_the_last_month: @commits_count_for_the_last_month, issues_count: @issues_count, commits_count: @commits_count)
  end

  def set_commit_activity
    response = @connection.get do |req|
      req.url "/repos/#{@repository.coin.owner}/#{@repository.name}/stats/commit_activity"
      req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
    end

    return if response.status == 404

    if response.status == 301
      response = @connection.get do |req|
        req.url response.headers["location"].gsub(CountCollector::REPOSITORY_API_URL_BASE, '')
        req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
      end
    end

    commit_activity = JSON.parse(response.body, {:symbolize_names => true}).reverse[0..4]
     
    @commits_count_for_the_last_week = commit_activity.last[:total]
    @commits_count_for_the_last_month = commit_activity.map{|b| b[:total]}.sum
  end 

  def set_language
    response = @connection.get do |req|
      req.url "/repos/#{@repository.coin.owner}/#{@repository.name}"
      req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
    end

    return if response.status == 404

    if response.status == 301
      response = @connection.get do |req|
        req.url response.headers["location"].gsub(CountCollector::REPOSITORY_API_URL_BASE, '')
        req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
      end
    end

    @language = JSON.parse(response.body, {:symbolize_names => true})[:language]
  end

  def set_contributors_count
    response = @connection.get do |req|
      req.url "/repos/#{@repository.coin.owner}/#{@repository.name}/contributors?per_page=100" # max 100
      req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
    end

    return if response.status == 404

    if response.status == 301
      response = @connection.get do |req|
        req.url response.headers["location"].gsub(CountCollector::REPOSITORY_API_URL_BASE, '')
        req.headers['Authorization'] = "token #{ENV['GITHUB_TOKEN']}"
      end
    end

    @contributors_count = JSON.parse(response.body).size
  end

  def scraping
    agent = Mechanize.new
    agent.user_agent_alias = 'Mac Safari'
    page = agent.get("#{CountCollector::REPOSITORY_URL_BASE}/#{@repository.coin.owner}/#{@repository.name}")

    if page.search('.Counter').size < 3
      @issues_count = nil
      @pull_requests_count = page.search('.Counter')[0].children.text.to_i
    else
      @issues_count = page.search('.Counter')[0].children.text.to_i
      @pull_requests_count = page.search('.Counter')[1].children.text.to_i
    end
    @commits_count = page.search('.text-emphasized')[0].children.text.gsub(/[^\d]/, "").to_i
    #@contributors_count = page.search('.text-emphasized')[3].children.text.gsub(/[^\d]/, "").to_i
    @watchers_count = page.search('.social-count')[0].children.text.gsub(/[^\d]/, "").to_i
    @stargazers_count = page.search('.social-count')[1].children.text.gsub(/[^\d]/, "").to_i
  end

  private
  def connection
    @conn = Faraday.new(:url => REPOSITORY_API_URL_BASE)
  end
end
