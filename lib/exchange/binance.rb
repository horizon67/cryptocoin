module Exchange
  class Binance

    def initialize(key, secret)
      @client = ::Binance::Client::REST.new(api_key: key, secret_key: secret)
    end

    def market_buy(amount)
      @client.create_order!(symbol: 'BTCUSDT', side: 'BUY', type: 'MARKET', quantity: amount)
    end

    def market_sell(amount)
      @client.create_order!(symbol: 'BTCUSDT', side: 'SELL', type: 'MARKET', quantity: amount)
    end

    def ticker
      res = @client.book_ticker(symbol: 'BTCUSDT')
      {
        bid: res['bidPrice'].to_f,
        ask: res['askPrice'].to_f
      }
    end
  end
end
