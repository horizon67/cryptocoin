class NotifyBestArbitrageBtcWorker
  include Sidekiq::Worker

  def perform(*args)
    exchanges = {}
    exchanges[:coincheck] = Exchange::Coincheck.ticker
    exchanges[:bitbank] = Exchange::Bitbank.ticker
    exchanges[:bitflyer] = Exchange::Bitflyer.ticker
    exchanges[:zaif] = Exchange::Zaif.ticker

    res = Faraday.get "https://www.btcbox.co.jp/api/v1/ticker/"
    # 気配値なのでsell,buyを逆にしてる
    exchanges[:btcbox] = {bid: JSON.parse(res.body, {:symbolize_names => true})[:buy].to_i,
                          ask: JSON.parse(res.body, {:symbolize_names => true})[:sell].to_i}

    exchanges[:quoine] = Exchange::Quoine.ticker

    res = Faraday.get "https://api.fcce.jp/api/1/ticker/btc_jpy"
    exchanges[:fcce] = {bid: JSON.parse(res.body, {:symbolize_names => true})[:bid].to_i,
                        ask: JSON.parse(res.body, {:symbolize_names => true})[:ask].to_i}
    best_bid = exchanges.map{|e| [e.first, e.second[:bid]] }.to_h.max{ |x, y| x[1] <=> y[1] }
    best_ask = exchanges.map{|e| [e.first, e.second[:ask]] }.to_h.min{ |x, y| x[1] <=> y[1] }

    arbitrage = best_bid.last - best_ask.last
    if noticeable?(arbitrage)
      if (Settings.config.notify_best_arbitrage_btc.notify_limit * 2) <= arbitrage
        surround = "`"
      elsif (Settings.config.notify_best_arbitrage_btc.notify_limit * 1.5) <= arbitrage
        surround = "*"
      else
        surround = ""
      end
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
      message = <<-EOS
        #{surround}[#{Time.zone.now}][arbitrage] best_ask: #{best_ask.last.to_s(:delimited)}(#{best_ask.first}), best_bid: #{best_bid.last.to_s(:delimited)}(#{best_bid.first}), arb: #{arbitrage.to_s(:delimited)}#{surround}
EOS
      
      notifier.ping message
    end

    ArbitrageBtc.create!(best_ask_price: best_ask.last,
                         best_bid_price: best_bid.last,
                         best_ask_exchange: best_ask.first,
                         best_bid_exchange: best_bid.first,
                         arbitrage: arbitrage)

  end

  def noticeable?(arbitrage)
    # 差が設定ファイルに定義している数値以上開いた、かつ過去5分以内に通知した差より1000以上大きければ通知
    Settings.config.notify_best_arbitrage_btc.notify_limit <= arbitrage and
      (ArbitrageBtc.where('created_at >= ?', 10.minute.ago).order('arbitrage desc').first&.arbitrage || 0) + 1000 <= arbitrage
  end
end
