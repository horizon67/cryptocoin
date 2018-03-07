class NotifyShootingUpDownBtcUsdWorker
  include Sidekiq::Worker

  def perform(*args)
    res = Faraday.get "https://www.bitmex.com/api/v1/instrument/active"
    hash = JSON.parse(res.body, {:symbolize_names => true})
    xbt = hash.find {|h| h[:symbol] == "XBTUSD"}
    prev = BtcUsd.last
    current = BtcUsd.create!(last: xbt[:lastPrice], bid: xbt[:bidPrice], ask: xbt[:askPrice])
    rate = (current.last.to_f / prev.last.to_f) * 100 - 100
    logger.info "up down rate: #{rate}"
    if rate >= Settings.config.notify_shooting_up.notify_limit
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "[#{Time.zone.now}][BtcUsd][#{current.created_at - prev.created_at} seconds increase rate] #{rate} "
    elsif rate <= Settings.config.notify_shooting_down.notify_limit
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "[#{Time.zone.now}][BtcUsd][#{current.created_at - prev.created_at} seconds decrease rate] #{rate} "
    end
  end
end
