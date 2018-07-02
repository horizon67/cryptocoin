class MexMakerBotWorker
  include Sidekiq::Worker
  sidekiq_options retry: 0

  def perform(*args)
    bitmex = Exchange::Bitmex.new(ENV["BITMEX_API_KEY"], ENV["BITMEX_API_SECRET"])
    cancel_order(bitmex)

    # 最終価格取得
    mex_ticker = bitmex.ticker

    #if bitmex.get_open_orders.size == 0
    exec_qty = bitmex.position.last["currentQty"]
    # ポジションがあれば利確 or 損切り
    if exec_qty < 0
      bitmex.limit_buy(exec_qty.abs, mex_ticker[:ask].to_f - 0.5)
    elsif exec_qty > 0
      bitmex.limit_sell(exec_qty, mex_ticker[:bid].to_f + 0.5)
    end
    #end

    # 新規注文
    if orderable?(bitmex)
      # 機械学習による予測値取得
      if mex_ticker[:last].to_f < PredictPrice.last.price.to_f
        bitmex.limit_buy(Settings.config.mex_maker_bot.amount, hash[:last_price].to_f - 0.5)
      else
        bitmex.limit_sell(Settings.config.mex_maker_bot.amount, hash[:last_price].to_f + 0.5)
      end
    end
  end

  private
  def orderable?(bitmex)
    (bitmex.position.last["isOpen"] == false) and (bitmex.get_open_orders.size == 0)
  end

  def cancel_order(bitmex)
    bitmex.get_open_orders.each do |order|
      bitmex.cancel_order(order["orderID"], order["clOrdID"]) if (order["timestamp"].in_time_zone('Tokyo') + 1.minutes) < Time.zone.now
    end
  end
end
