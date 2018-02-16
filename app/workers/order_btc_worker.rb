class OrderBtcWorker
  include Sidekiq::Worker

  def perform(*args)
    amount = 0.5
    logger.info "OrderBtcWorker_quoine_bitbank: #{Exchange::Bitbank.ticker[:bid] - Exchange::Quoine.ticker[:ask]}"
    logger.info "OrderBtcWorker_bitflyer_bitbank: #{Exchange::Bitbank.ticker[:bid] - Exchange::Bitflyer.ticker[:ask]}"
    logger.info "OrderBtcWorker_zaif_bitbank: #{Exchange::Bitbank.ticker[:bid] - Exchange::Zaif.ticker[:ask]}"
    logger.info "OrderBtcWorker_quoine_zaif: #{Exchange::Zaif.ticker[:bid] - Exchange::Quoine.ticker[:ask]}"
    diff = Exchange::Bitbank.ticker[:bid] - Exchange::Quoine.ticker[:ask]
    if diff.to_f > 55000 and Exchange::Bitbank.balances[:btc].to_f > amount.to_f
      logger.info "Transaction start"
      logger.info "Bitbank: #{Exchange::Bitbank.balances}"
      logger.info "Quoine: #{Exchange::Quoine.balances}"
      ret = Exchange::Bitbank.market_sell(amount)
      logger.info ret
      ret = Exchange::Quoine.market_buy(amount)
      logger.info ret
      logger.info "Bitbank: #{Exchange::Bitbank.balances}"
      logger.info "Quoine: #{Exchange::Quoine.balances}"

      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "Transaction Success.. Amount: #{amount}, Arbitrage: #{diff}"
      logger.info "Transaction end"
    end
    #Exchange::Coincheck.market_buy(0.5)
    #Exchange::Bitbank.market_sell(0.5)
  end
end
