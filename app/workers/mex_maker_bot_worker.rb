class MexMakerBotWorker
  include Sidekiq::Worker

  def perform(*args)
    bitmex = Exchange::Bitmex.new(ENV["BITMEX_API_KEY"], ENV["BITMEX_API_SECRET"])
    cancel_order(bitmex)

    if bitmex.get_open_orders.size == 0
      exec_qty = bitmex.position.last["currentQty"]
      # ポジションがあれば利確 or 損切り
      if exec_qty < 0
        bitmex.limit_buy(exec_qty.abs, BtcUsd.last.ask - 0.5)
      elsif exec_qty > 0
        bitmex.limit_sell(exec_qty, BtcUsd.last.bid + 0.5)
      end
    end
    # TODO: waitして注文状況を確認。注文が通ってなければキャンセルし再度注文みたいなことをやる

    # 新規注文
    if orderable?(bitmex)
      before_price = BtcUsd.where("created_at < ?", 3.minute.ago).last.last
      now_price = BtcUsd.last.last
      if before_price < now_price
        bitmex.limit_buy(Settings.config.mex_maker_bot.amount, BtcUsd.last.ask - 0.5)
      else
        bitmex.limit_sell(Settings.config.mex_maker_bot.amount, BtcUsd.last.bid + 0.5)
      end
    end
  end

  private
  def orderable?(bitmex)
    (bitmex.position.last["isOpen"] == false) and (bitmex.get_open_orders.size == 0)
  end

  def cancel_order(bitmex)
    bitmex.get_open_orders.each do |order|
      bitmex.cancel_order(order["orderID"], order["clOrdID"]) if (order["timestamp"].in_time_zone('Tokyo') + 3.minutes) < Time.zone.now
    end
  end
end
