module Exchange
  class Zaif
    def self.market_buy(amount)
      client.ask("btc", (ticker[:ask] * amount).floor, amount)
    end

    def self.market_sell(amount)
      client.bid("btc", (ticker[:bid] * amount).floor, amount)
    end

    def self.balances
      balances = Exchange::Zaif::client.get_info["funds"]
      {jpy: balances["jpy"],
       btc: balances["btc"]}
    end

    def self.ticker
      res = client.get_ticker("btc")
      {bid: res["bid"].to_i,
       ask: res["ask"].to_i}
    end

    private

    def self.client
      @@client ||= ::Zaif::API.new(api_key: ENV["ZAIF_API_KEY"], api_secret: ENV["ZAIF_API_SECRET"])
    end
  end
end
