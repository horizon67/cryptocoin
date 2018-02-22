class OrderBtcWorker
  include Sidekiq::Worker

  def perform(*args)
    amount = Settings.config.order_btc.amount
    logger.info "OrderBtcWorker_quoine_zaif: #{Exchange::Zaif.ticker[:bid] - Exchange::Quoine.ticker[:ask]}"
    logger.info "OrderBtcWorker_quoine_bitflyer: #{Exchange::Bitflyer.ticker[:bid] - Exchange::Quoine.ticker[:ask]}"
    diff = Exchange::Bitflyer.ticker[:bid] - Exchange::Quoine.ticker[:ask]
    if diff.to_f >= Settings.config.order_btc.target_profit and 
       Exchange::Bitflyer.balances[:btc].to_f >= amount.to_f and
       Exchange::Quoine.balances[:jpy].to_f >= (Exchange::Quoine.ticker[:ask] * amount.to_f)
      logger.info "OrderStart"
      logger.info "Quoine: #{Exchange::Quoine.balances}"
      logger.info "Bitflyer: #{Exchange::Bitflyer.balances}"
      ret = Exchange::Bitflyer.market_sell(amount)
      logger.info ret
      ret = Exchange::Quoine.market_buy(amount)
      logger.info ret
      logger.info "Quoine: #{Exchange::Quoine.balances}"
      logger.info "Bitflyer: #{Exchange::Bitflyer.balances}"

      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "Order Success.. Amount: #{amount}, Arbitrage: #{diff}"
      logger.info "OrderEnd"
    else
      logger.info "NotOrderd: #{diff.to_f}, #{Exchange::Bitflyer.balances[:btc].to_f}, #{Exchange::Quoine.balances[:jpy].to_f}"
    end
  rescue => e
    logger.error "OrderBtcWorker: #{e.message}"
  end
end
