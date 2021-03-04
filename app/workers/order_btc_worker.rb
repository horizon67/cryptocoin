class OrderBtcWorker
  include Sidekiq::Worker

  def perform(dry_run: false)
    sell_klass_name = AppConfig.arb_sell_ex.classify
    sell_klass = "Exchange::#{sell_klass_name}".constantize.new(ENV["#{sell_klass_name.upcase}_API_KEY"], ENV["#{sell_klass_name.upcase}_API_SECRET"])

    buy_klass_name = AppConfig.arb_buy_ex.classify
    buy_klass = "Exchange::#{buy_klass_name}".constantize.new(ENV["#{buy_klass_name.upcase}_API_KEY"], ENV["#{buy_klass_name.upcase}_API_SECRET"])

    profit = sell_klass.ticker[:bid] - buy_klass.ticker[:ask]
    buy_ex_balances = buy_klass.balances
    sell_ex_balances = sell_klass.balances

    unless orderable?(sell_klass, buy_klass, profit)
      logger.info "[ORDER_LOG] NOT_ORDERD.. Profit: #{profit.to_f}, #{buy_klass_name} Balances: #{buy_ex_balances}, #{sell_klass_name} Balances: #{sell_ex_balances}"
      return
    end

    logger.info "[ORDER_LOG] OrderStart -- Buy: #{buy_klass_name}, Sell: #{sell_klass_name}"
    logger.info "[ORDER_LOG] #{buy_klass_name} Balances: #{buy_ex_balances}"
    logger.info "[ORDER_LOG] #{sell_klass_name} Balances: #{sell_ex_balances}"
    logger.info "[ORDER_LOG] total jpy: #{buy_ex_balances[:jpy] + sell_ex_balances[:jpy]}"
    logger.info "[ORDER_LOG] total btc: #{buy_ex_balances[:btc] + sell_ex_balances[:btc]}"
    unless dry_run
      # 成り買い
      logger.info "[ORDER_LOG][BUY] #{buy_klass.market_buy(AppConfig.arb_amount)}"
      if buy_klass.balances[:btc] == buy_ex_balances[:btc]
        raise "#{buy_klass_name} failed buy"
      end
      # 成り売り
      logger.info "[ORDER_LOG][SELL] #{sell_klass.market_sell(AppConfig.arb_amount)}"
      3.times do
        break unless sell_klass.balances[:btc] == sell_ex_balances[:btc]

        logger.info "[ORDER_LOG] #{sell_klass_name} failed sell. retry.."
        sleep 1
        logger.info "[ORDER_LOG][SELL] #{sell_klass.market_sell(AppConfig.arb_amount)}"
        sleep 1
      end
    end
    logger.info success_message(profit)
    logger.info "[ORDER_LOG] #{buy_klass_name} Balances: #{buy_klass.balances}"
    logger.info "[ORDER_LOG] #{sell_klass_name} Balances: #{sell_klass.balances}"
    logger.info "[ORDER_LOG] total jpy: #{buy_klass.balances[:jpy] + sell_klass.balances[:jpy]}"
    logger.info "[ORDER_LOG] total btc: #{buy_klass.balances[:btc] + sell_klass.balances[:btc]}"

    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.ping success_message(profit)
    logger.info "[ORDER_LOG] OrderEnd -- Buy: #{buy_klass_name}, Sell: #{buy_klass_name}"
  rescue => e
    logger.error e.message
  end

  private

  def orderable?(sell_klass, buy_klass, profit)
    if profit.to_f < AppConfig.arb_target_profit
      logger.info "[ORDER_LOG][ORDERABLE] The target amount has not been reached. #{profit.to_f}"
      return false
    end

    if sell_klass.balances[:btc].to_f < AppConfig.arb_amount.to_f
      logger.info "[ORDER_LOG][ORDERABLE] Insufficient funds. BTC to sell. #{sell_klass.balances[:btc].to_f}"
      return false
    end

    if buy_klass.balances[:jpy].to_f < (buy_klass.ticker[:ask] * AppConfig.arb_amount.to_f)
      logger.info "[ORDER_LOG][ORDERABLE] Insufficient funds. JPY to buy. #{buy_klass.balances[:jpy].to_f}"
      return false
    end

    true
  end

  def success_message(profit)
    "[ORDER_LOG] Order Success. Amount: #{AppConfig.arb_amount}, Profits: #{profit}"
  end
end
