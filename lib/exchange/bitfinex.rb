require './lib/bitfinex/bitfinex'
module Exchange
  class Bitfinex

    def initialize(key, secret)
      @client = ::Bitfinex.http_private_client(key, secret)
    end

    def market_buy(amount)
      @client.create_order('tBTCUSD', 'EXCHANGE MARKET', amount)
    end

    def market_sell(amount)
      @client.create_order('tBTCUSD', 'EXCHANGE MARKET', (-amount).to_s)
    end

    def ticker
      res = Faraday.get 'https://api-pub.bitfinex.com/v2/tickers?symbols=tBTCUSD'
      tickers = JSON.parse(res.body).first
      {
        bid: tickers[1].to_f,
        ask: tickers[3].to_f
      }
    end
  end
end
