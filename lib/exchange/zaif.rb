module Exchange
  class Zaif

    def initialize(key, secret)
      @client = ::Zaif::API.new(api_key: key, api_secret: secret)
    end

    def market_buy(amount)
      @client.bid("btc", ((ticker[:ask] + 100).to_s.chop + '0').to_i, amount)
    end

    def market_sell(amount)
      @client.ask("btc", ((ticker[:bid] - 100).to_s.chop + '0').to_i, amount)
    end

    def balances
      balances = @client.get_info["funds"]
      {jpy: balances["jpy"],
       btc: balances["btc"]}
    end

    def ticker
      res = @client.get_ticker("btc")
      {bid: res["bid"].to_i,
       ask: res["ask"].to_i}
    end
  end
end
