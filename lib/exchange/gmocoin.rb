require './lib/gmocoin/gmocoin'
module Exchange
  class Gmocoin

    def initialize(key, secret)
      @private_client = ::Gmocoin.http_private_client(key, secret)
      @public_client = ::Gmocoin.http_public_client
    end

    def market_buy(amount)
    end

    def market_sell(amount)
    end

    def balances
      res = @private_client.assets[:data]
      {
        jpy: res.find{ |d| d[:symbol] == 'JPY' }[:amount].to_f,
        btc: res.find{ |d| d[:symbol] == 'BTC' }[:amount].to_f
      }
    end

    def ticker(symbol='BTC')
      res = @public_client.ticker(symbol: symbol)[:data].first
      { bid: res[:bid],  ask: res[:ask] }
    end
  end
end
