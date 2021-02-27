class MexTakerBotWorker
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
    logger.info bitmex.ticker
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

  def bitmex
    @bitmex ||= Exchange::Bitmex.new(ENV["BITMEX_API_KEY"], ENV["BITMEX_API_SECRET"])
  end

  def order(side)
    exec_qty = bitmex.position.last["currentQty"]
    bitmex.send("market_#{side}", Settings.config.toreten.amount + exec_qty.abs)
  end
end
