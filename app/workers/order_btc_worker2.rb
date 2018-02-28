class OrderBtcWorker2
  include Sidekiq::Worker

  def perform(dry_run: false)
    sell_klass_name = Settings.config.order_btc2.sell_ex.classify
    sell_klass = "Exchange::#{sell_klass_name}".constantize.new(ENV["#{sell_klass_name.upcase}_API_KEY2"], ENV["#{sell_klass_name.upcase}_API_SECRET2"])

    buy_klass_name = Settings.config.order_btc2.buy_ex.classify
    buy_klass = "Exchange::#{buy_klass_name}".constantize.new(ENV["#{buy_klass_name.upcase}_API_KEY2"], ENV["#{buy_klass_name.upcase}_API_SECRET2"])

    profit = sell_klass.ticker[:bid] - buy_klass.ticker[:ask]
    if orderable?(sell_klass, buy_klass, profit)
      logger.info "[ORDER_LOG] OrderStart -- Buy: #{buy_klass_name}, Sell: #{buy_klass_name}"
      logger.info "[ORDER_LOG] #{buy_klass_name} Balances: #{buy_klass.balances}"
      logger.info "[ORDER_LOG] #{sell_klass_name} Balances: #{sell_klass.balances}"
      unless dry_run
        buy_klass.market_buy(Settings.config.order_btc2.amount)
        sell_klass.market_sell(Settings.config.order_btc2.amount)
      end
      logger.info "[ORDER_LOG] Order Success."
      logger.info "[ORDER_LOG] #{buy_klass_name} Balances: #{buy_klass.balances}"
      logger.info "[ORDER_LOG] #{sell_klass_name} Balances: #{sell_klass.balances}"

      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      notifier.ping "[#{self.class.name}] Order Success. Amount: #{Settings.config.order_btc2.amount}, Estimated Profits: #{profit * Settings.config.order_btc2.amount}"
      logger.info "[ORDER_LOG] OrderEnd -- Buy: #{buy_klass_name}, Sell: #{buy_klass_name}"
    else
      logger.info "[ORDER_LOG] NOT_ORDERD.. Profit: #{profit.to_f}, #{buy_klass_name} Balances: #{buy_klass.balances[:jpy].to_f}, #{sell_klass_name} Balances: #{sell_klass.balances[:btc].to_f}"
    end
  end

  def orderable?(sell_klass, buy_klass, profit)
    if profit.to_f >= Settings.config.order_btc2.target_profit and
       sell_klass.balances[:btc].to_f >= Settings.config.order_btc2.amount.to_f and
       buy_klass.balances[:jpy].to_f >= (buy_klass.ticker[:ask] * Settings.config.order_btc2.amount.to_f)
    end
  end
end
