class OrderBtcUsdWorker
  include Sidekiq::Worker

  def perform()
    sell_klass_name = AppConfig.arb_sell_ex.classify
    sell_klass = "Exchange::#{sell_klass_name}".constantize.new(ENV["#{sell_klass_name.upcase}_API_KEY"], ENV["#{sell_klass_name.upcase}_API_SECRET"])

    buy_klass_name = AppConfig.arb_buy_ex.classify
    buy_klass = "Exchange::#{buy_klass_name}".constantize.new(ENV["#{buy_klass_name.upcase}_API_KEY"], ENV["#{buy_klass_name.upcase}_API_SECRET"])

    buy_ex_ticker = buy_klass.ticker
    sell_ex_ticker = sell_klass.ticker

    profit = sell_ex_ticker[:bid] - buy_ex_ticker[:ask]
    arb_amount = AppConfig.arb_amount
    logger.info "[ORDER_LOG] arb_amount: #{arb_amount}"

    unless orderable?(profit)
      logger.info "[ORDER_LOG] NOT_ORDERD.. Profit: #{profit.to_f}, #{buy_klass_name}"
      return
    end

    logger.info "[ORDER_LOG] OrderStart -- Buy: #{buy_klass_name}, Sell: #{sell_klass_name}"
    # 成り買い
    # 成行手数料(0.2%) + 出金手数料(0.0003) を考慮
    logger.info "[ORDER_LOG][BUY] #{buy_klass.market_buy((arb_amount * 1.002 + 0.0003).floor(4))}"
    # 成り売り
    logger.info "[ORDER_LOG][SELL] #{sell_klass.market_sell(arb_amount)}"
    logger.info success_message(profit, arb_amount)

    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.ping success_message(profit, arb_amount)
    logger.info "[ORDER_LOG] OrderEnd -- Buy: #{buy_klass_name}, Sell: #{buy_klass_name}"

    AppConfig.arb_target_profit = 99999
  rescue => e
    logger.error e.message
  end

  private

  def orderable?(profit)
    if profit.to_f < AppConfig.arb_target_profit
      logger.info "[ORDER_LOG][ORDERABLE] The target amount has not been reached. #{profit.to_f}"
      return false
    end

    true
  end

  def success_message(profit, arb_amount)
    "[ORDER_LOG] Order Success. Amount: #{arb_amount}, Profits: #{profit}"
  end
end
