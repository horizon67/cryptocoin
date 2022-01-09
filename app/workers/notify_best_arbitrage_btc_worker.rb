class NotifyBestArbitrageBtcWorker
  include Sidekiq::Worker

  def perform(*args)
    exchanges = {}
    exchanges[:coincheck] = Exchange::Coincheck.new(ENV["COINCHECK_API_KEY"], ENV["COINCHECK_API_SECRET"]).ticker
    exchanges[:bitbank] = Exchange::Bitbank.new(ENV["BITBANK_API_KEY"], ENV["BITBANK_API_SECRET"]).ticker
    exchanges[:bitflyer] = Exchange::Bitflyer.new(ENV["BITFLYER_API_KEY"], ENV["BITFLYER_API_SECRET"]).ticker
    exchanges[:zaif] = Exchange::Zaif.new(ENV["ZAIF_API_KEY"], ENV["ZAIF_API_SECRET"]).ticker
    exchanges[:gmocoin] = Exchange::Gmocoin.new(ENV['GMOCOIN_API_KEY'], ENV['GMOCOIN_API_SECRET']).ticker

    res = Faraday.get "https://www.btcbox.co.jp/api/v1/ticker/"
    # 気配値なのでsell,buyを逆にしてる
    exchanges[:btcbox] = {bid: JSON.parse(res.body, {:symbolize_names => true})[:buy].to_i,
                          ask: JSON.parse(res.body, {:symbolize_names => true})[:sell].to_i}

    exchanges[:quoine] = Exchange::Quoine.new(ENV["QUOINE_API_KEY1"], ENV["QUOINE_API_SECRET1"]).ticker

    best_bid = exchanges.map{|e| [e.first, e.second[:bid]] }.to_h.max{ |x, y| x[1] <=> y[1] }
    best_ask = exchanges.map{|e| [e.first, e.second[:ask]] }.to_h.min{ |x, y| x[1] <=> y[1] }

    arbitrage = best_bid.last - best_ask.last
    if should_notify?(arbitrage)
      notify!(arbitrage, best_bid, best_ask)
    end

    ArbitrageBtc.create!(best_ask_price: best_ask.last,
                         best_bid_price: best_bid.last,
                         best_ask_exchange: best_ask.first,
                         best_bid_exchange: best_bid.first,
                         arbitrage: arbitrage)

    logger.info "Diff : QuoineCoincheck #{exchanges[:coincheck][:bid] - exchanges[:quoine][:ask]}"
    logger.info "Diff : QuoineZaif #{exchanges[:zaif][:bid] - exchanges[:quoine][:ask]}"
    logger.info "Diff : QuoineBitflyer #{exchanges[:bitflyer][:bid] - exchanges[:quoine][:ask]}"
    logger.info "Diff : QuoineBitbank #{exchanges[:bitbank][:bid] - exchanges[:quoine][:ask]}"
    logger.info "Diff : ZaifBitflyer #{exchanges[:bitflyer][:bid] - exchanges[:zaif][:ask]}"
    logger.info "Diff : BitflyerZaif #{exchanges[:zaif][:bid] - exchanges[:bitflyer][:ask]}"
    logger.info "Diff : CoincheckQuoine #{exchanges[:quoine][:bid] - exchanges[:coincheck][:ask]}"
    logger.info "Diff : CoincheckZaif #{exchanges[:zaif][:bid] - exchanges[:coincheck][:ask]}"
    logger.info "Diff : CoincheckBitbank #{exchanges[:bitbank][:bid] - exchanges[:coincheck][:ask]}"
    logger.info "Diff : CoincheckBitflyer #{exchanges[:bitflyer][:bid] - exchanges[:coincheck][:ask]}"
    logger.info "Diff : GmocoinZaif #{exchanges[:gmocoin][:bid] - exchanges[:zaif][:ask]}"
    logger.info "Diff : CoincheckGmocoin #{exchanges[:coincheck][:bid] - exchanges[:gmocoin][:ask]}"



    # USD
    exchanges = {}
    res = Faraday.get 'https://api.pro.coinbase.com/products/BTC-USD/ticker'
    exchanges[:coinbase] = { bid: JSON.parse(res.body)['bid'].to_f, ask: JSON.parse(res.body)['ask'].to_f }

    res = Faraday.get 'https://api.binance.com/api/v3/ticker/bookTicker?symbol=BTCUSDT'
    exchanges[:binace] = { bid: JSON.parse(res.body)['bidPrice'].to_f, ask: JSON.parse(res.body)['askPrice'].to_f }

    res = Faraday.get 'https://api.kraken.com/0/public/Ticker?pair=XBTUSD'
    exchanges[:kraken] = { bid: JSON.parse(res.body)['result']['XXBTZUSD']['b'].first.to_f,
                           ask: JSON.parse(res.body)['result']['XXBTZUSD']['a'].first.to_f }

    res = Faraday.get 'https://api.bitfinex.com/v1/pubticker/btcusd'
    exchanges[:bitfinex] = { bid: JSON.parse(res.body)['bid'].to_f, ask: JSON.parse(res.body)['ask'].to_f }

    res = Faraday.get 'https://data.gateapi.io/api2/1/ticker/btc_usdt'
    exchanges[:gateio] = { bid: JSON.parse(res.body)['highestBid'].to_f, ask: JSON.parse(res.body)['lowestAsk'].to_f }

    res = Faraday.get 'https://ftx.com/api/markets/BTC/USD'
    exchanges[:ftx] = { bid: JSON.parse(res.body)['result']['bid'].to_f, ask: JSON.parse(res.body)['result']['ask'].to_f }

    res = Faraday.get 'https://api.bittrex.com/v3/markets/BTC-USD/ticker'
    exchanges[:bittrex] = { bid: JSON.parse(res.body)['bidRate'].to_f, ask: JSON.parse(res.body)['askRate'].to_f }

    best_bid = exchanges.map{|e| [e.first, e.second[:bid]] }.to_h.max{ |x, y| x[1] <=> y[1] }
    best_ask = exchanges.map{|e| [e.first, e.second[:ask]] }.to_h.min{ |x, y| x[1] <=> y[1] }
    arbitrage = best_bid.last - best_ask.last

    ArbitrageUsdBtc.create!(best_ask_price: best_ask.last,
                            best_bid_price: best_bid.last,
                            best_ask_exchange: best_ask.first,
                            best_bid_exchange: best_bid.first,
                            arbitrage: arbitrage)
  end

  def should_notify?(arbitrage)
    # 差が設定ファイルに定義している数値以上開いた、かつ過去20分以内に通知した差より1000以上大きければ通知
    Settings.config.notify_best_arbitrage_btc.notify_limit <= arbitrage and
      (ArbitrageBtc.where('created_at >= ?', 20.minute.ago).order('arbitrage desc').first&.arbitrage || 0) + 1000 <= arbitrage
  end

  def notify!(arbitrage, best_bid, best_ask)
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
end
