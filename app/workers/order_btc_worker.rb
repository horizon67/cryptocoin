class OrderBtcWorker
  include Sidekiq::Worker

  def perform(*args)
    amount = Settings.config.order_btc.amount
    logger.info "OrderBtcWorker_quoine_zaif: #{Exchange::Zaif.ticker[:bid] - Exchange::Quoine.ticker[:ask]}"
    logger.info "OrderBtcWorker_quoine_bitflyer: #{Exchange::Bitflyer.ticker[:bid] - Exchange::Quoine.ticker[:ask]}"
    diff = Exchange::Bitbank.ticker[:bid] - Exchange::Quoine.ticker[:ask]
    if diff.to_f >= Settings.config.order_btc.target_profit and 
       Exchange::Bitbank.balances[:btc].to_f >= amount.to_f and
       Exchange::Quoine.balances[:jpy].to_f >= (Exchange::Quoine.ticker[:ask] * amount.to_f)
      logger.info "Order start"
      logger.info "Quoine: #{Exchange::Quoine.balances}"
      logger.info "Bitbank: #{Exchange::Bitbank.balances}"
      ret = Exchange::Quoine.market_buy(amount)
      logger.info ret
      ret = Exchange::Bitbank.market_sell(amount)
      logger.info ret
      logger.info "Quoine: #{Exchange::Quoine.balances}"
      logger.info "Bitbank: #{Exchange::Bitbank.balances}"

      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "Order Success.. Amount: #{amount}, Arbitrage: #{diff}"
      logger.info "Order end"
    else
      logger.info "NotOrderd: #{diff.to_f}, #{Exchange::Bitbank.balances[:btc].to_f}, #{Exchange::Quoine.balances[:jpy].to_f}"
    end
  end
end
