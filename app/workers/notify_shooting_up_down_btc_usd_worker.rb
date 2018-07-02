class NotifyShootingUpDownBtcUsdWorker
  include Sidekiq::Worker

  def perform(*args)
    bitmex = Exchange::Bitmex.new(ENV["BITMEX_API_KEY"], ENV["BITMEX_API_SECRET"])
    res = Faraday.get "https://www.bitmex.com/api/v1/instrument/active"
    hash = JSON.parse(res.body, {:symbolize_names => true})
    xbt = hash.find {|h| h[:symbol] == "XBTUSD"}
    prev = BtcUsd.last
    current = BtcUsd.create!(last: xbt[:lastPrice], bid: xbt[:bidPrice], ask: xbt[:askPrice])
    rate = (current.last.to_f / prev.last.to_f) * 100 - 100
    logger.info "up down rate: #{rate}"
    exec_qty = bitmex.position.last["currentQty"]
    if rate >= Settings.config.notify_shooting_up.notify_limit
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "[#{Time.zone.now}][BtcUsd][#{current.created_at - prev.created_at} seconds increase rate] #{rate} " if Rails.evn.production?
      # 損切り
      if exec_qty < 0
        bitmex.market_buy(exec_qty.abs)
      end
    elsif rate <= Settings.config.notify_shooting_down.notify_limit
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "[#{Time.zone.now}][BtcUsd][#{current.created_at - prev.created_at} seconds decrease rate] #{rate} " if Rails.evn.production?
      # 損切り
      if exec_qty > 0
        bitmex.market_sell(exec_qty)
      end
    end
  end
end
