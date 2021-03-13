class NotifyBestArbitrageEthWorker
  include Sidekiq::Worker

  def perform(*args)
    exchanges = {}
    res = Faraday.get 'https://api.pro.coinbase.com/products/ETH-USD/ticker'
    exchanges[:coinbase] = { bid: JSON.parse(res.body)['bid'].to_f, ask: JSON.parse(res.body)['ask'].to_f }

    res = Faraday.get 'https://api.binance.com/api/v3/ticker/bookTicker?symbol=ETHUSDT'
    exchanges[:binace] = { bid: JSON.parse(res.body)['bidPrice'].to_f, ask: JSON.parse(res.body)['askPrice'].to_f }

    res = Faraday.get 'https://api.kraken.com/0/public/Ticker?pair=XETHZUSD'
    exchanges[:kraken] = { bid: JSON.parse(res.body)['result']['XETHZUSD']['b'].first.to_f,
                           ask: JSON.parse(res.body)['result']['XETHZUSD']['a'].first.to_f }

    res = Faraday.get 'https://api.bitfinex.com/v1/pubticker/ethusd'
    exchanges[:bitfinex] = { bid: JSON.parse(res.body)['bid'].to_f, ask: JSON.parse(res.body)['ask'].to_f }

    res = Faraday.get 'https://data.gateapi.io/api2/1/ticker/eth_usdt'
    exchanges[:gateio] = { bid: JSON.parse(res.body)['highestBid'].to_f, ask: JSON.parse(res.body)['lowestAsk'].to_f }

    res = Faraday.get 'https://bitmax.io/api/pro/v1/ticker?symbol=ETH/USDT'
    exchanges[:bitmax] = { bid: JSON.parse(res.body)['data']['bid'].first.to_f, ask: JSON.parse(res.body)['data']['ask'].first.to_f }

    res = Faraday.get 'https://ftx.com/api/markets/ETH/USD'
    exchanges[:ftx] = { bid: JSON.parse(res.body)['result']['bid'].to_f, ask: JSON.parse(res.body)['result']['ask'].to_f }

    res = Faraday.get 'https://api.bittrex.com/v3/markets/ETH-USD/ticker'
    exchanges[:ftx] = { bid: JSON.parse(res.body)['bidRate'].to_f, ask: JSON.parse(res.body)['askRate'].to_f }

    best_bid = exchanges.map{|e| [e.first, e.second[:bid]] }.to_h.max{ |x, y| x[1] <=> y[1] }
    best_ask = exchanges.map{|e| [e.first, e.second[:ask]] }.to_h.min{ |x, y| x[1] <=> y[1] }
    arbitrage = best_bid.last - best_ask.last

    ArbitrageUsdEth.create!(best_ask_price: best_ask.last,
                            best_bid_price: best_bid.last,
                            best_ask_exchange: best_ask.first,
                            best_bid_exchange: best_bid.first,
                            arbitrage: arbitrage)
  end
end
