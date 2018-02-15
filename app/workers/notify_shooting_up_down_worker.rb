class NotifyShootingUpDownWorker
  include Sidekiq::Worker

  def perform(*args)
    res = Faraday.get "https://coincheck.com/api/ticker"
    hash = JSON.parse(res.body, {:symbolize_names => true})
    BtcJpy.create!(last: hash[:last], bid: hash[:bid], ask: hash[:ask])

    btc_jpys = BtcJpy.order("id desc").limit(3)
    rate = (btc_jpys.first.last.to_f / btc_jpys.last.last.to_f) * 100 - 100
    logger.info "up down rate: #{rate}"
    if rate >= Settings.config.notify_shooting_up.notify_limit
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "[#{Time.zone.now}][#{btc_jpys.first.created_at - btc_jpys.last.created_at} seconds increase rate] #{rate} "
    elsif rate <= Settings.config.notify_shooting_down.notify_limit
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "[#{Time.zone.now}][#{btc_jpys.first.created_at - btc_jpys.last.created_at} seconds decrease rate] #{rate} "
    end
  end
end
