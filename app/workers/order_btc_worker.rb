class OrderBtcWorker
  include Sidekiq::Worker

  def perform(*args)
    amount = 0.5
    logger.info "OrderBtcWorker_quoine_bitbank: #{Exchange::Bitbank.ticker[:bid] - Exchange::Quoine.ticker[:ask]}"
    logger.info "OrderBtcWorker_bitflyer_bitbank: #{Exchange::Bitbank.ticker[:bid] - Exchange::Bitflyer.ticker[:ask]}"
    logger.info "OrderBtcWorker_zaif_bitbank: #{Exchange::Bitbank.ticker[:bid] - Exchange::Zaif.ticker[:ask]}"
    logger.info "OrderBtcWorker_quoine_zaif: #{Exchange::Zaif.ticker[:bid] - Exchange::Quoine.ticker[:ask]}"
    diff = Exchange::Zaif.ticker[:bid] - Exchange::Quoine.ticker[:ask]
    if diff.to_f > 7500 and Exchange::Zaif.balances[:btc].to_f > amount.to_f
      ret = Exchange::Zaif.market_sell(amount)
      logger.info ret
      ret = Exchange::Quoine.market_buy(amount)
      logger.info ret

      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "Transaction Success.. Amount: #{amount}, Arbitrage: #{diff}"
      logger.info "Transaction success!!"
    end
    #Exchange::Coincheck.market_buy(0.5)
    #Exchange::Bitbank.market_sell(0.5)
  end
end
