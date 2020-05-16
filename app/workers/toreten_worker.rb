class ToretenWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform(*args)
    latest_tweet = twitter.user_timeline('botkanshibot').first
    side_ja = latest_tweet.text.match(/トレ転！(.*)！/)[1]

    if redis.get('tweet_id') == latest_tweet.id.to_s
      logger.info "#{side_ja}中"
    else
      order(side_ja == 'ショート' ? 'sell' : 'buy')
      redis.set('tweet_id', latest_tweet.id.to_s)
      logger.info "トレ転！ #{side_ja}"
    end
    logger.info liquid.ticker
  end

  private

  def twitter
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def redis
    @redis ||= Redis.new
  end

  def liquid
    @liquid ||= Exchange::Quoine.new(ENV["QUOINE_API_KEY"], ENV["QUOINE_API_SECRET"])
  end

  def order(side)
    if liquid.trades({'status' => 'open'})['models'].present?
      response = liquid.trade_close_all.first
      logger.info "OPEN: #{response['open_price']}"
      logger.info "CLOSE: #{response['close_price']}"
      logger.info "DIFF: #{response['close_price'].to_f - response['open_price'].to_f}"
      logger.info response.inspect
    end

    liquid.send("leverage_market_#{side}",
                Settings.config.toreten.amount,
                Settings.config.toreten.leverage_level)
  end
end
