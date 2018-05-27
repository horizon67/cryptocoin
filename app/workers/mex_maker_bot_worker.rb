class MexMakerBotWorker
  include Sidekiq::Worker

  def perform(*args)
    bitmex = Exchange::Bitmex.new(ENV["BITMEX_API_KEY"], ENV["BITMEX_API_SECRET"])
    exec_qty = bitmex.position.last["execQty"]
    # ポジションがあれば利確 or 損切り
    if exec_qty < 0
      bitmex.limit_buy(exec_qty.abs, BtcUsd.last.last - 0.5)
    elsif exec_qty > 0
      bitmex.limit_sell(exec_qty, BtcUsd.last.last - 0.5)
    end

    before_price = BtcUsd.where("created_at < ?", 10.minute.ago).last.last
    now_price = BtcUsd.last.last
    # 新規注文
    if before_price < now_price
      bitmex.limit_buy(Settings.config.mex_maker_bot.amount, BtcUsd.last.last - 0.5)
    else
      bitmex.limit_sell(Settings.config.mex_maker_bot.amount, BtcUsd.last.last - 0.5)
    end
    # TODO: waitして注文状況を確認。注文が通ってなければキャンセルし再度注文みたいなことをやる
  end
end
