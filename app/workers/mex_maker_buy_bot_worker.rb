class MexMakerBuyBotWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform(*args)
    bitmex = Exchange::Bitmex.new(ENV["BITMEX_API_KEY2"], ENV["BITMEX_API_SECRET2"])
    cancel_order(bitmex)

    # 最終価格取得
    mex_ticker = bitmex.ticker

    if bitmex.get_open_orders.size == 0
      if exec_qty = bitmex.position.last.dig(:currentQty)
        if exec_qty < 0
          bitmex.limit_buy(exec_qty.abs, mex_ticker[:last].to_f)
        elsif exec_qty > 0
          bitmex.limit_sell(exec_qty, mex_ticker[:last].to_f)
        end
      end
    end

    # 新規注文
    if orderable?(bitmex)
      bitmex.limit_buy(Settings.config.mex_maker_bot.amount, mex_ticker[:last].to_f)
    end
  end

  private
  def orderable?(bitmex)
    (bitmex.position.last[:isOpen] == false) and (bitmex.get_open_orders.size == 0)
  end

  def cancel_order(bitmex)
    bitmex.get_open_orders.each do |order|
      bitmex.cancel_order(order[:orderID], order[:clOrdID]) if (order[:timestamp].in_time_zone('Tokyo') + 4.minutes) < Time.zone.now
    end
  end
end
