module Exchange
  class Coincheck
    def self.market_buy(amount)
      client.create_orders(market_buy_amount: (ticker[:ask] * amount).floor, order_type: "market_buy")
    end

    def self.market_sell(amount)
      client.create_orders(amount: amount, order_type: "market_sell")
    end

    def self.balances
      res = client.read_balance
      {jpy: JSON.parse(res.body, {:symbolize_names => true})[:jpy],
       btc: JSON.parse(res.body, {:symbolize_names => true})[:btc]}
    end

    def self.ticker
      res = client.read_ticker
      {bid: JSON.parse(res.body, {:symbolize_names => true})[:bid].to_i,
       ask: JSON.parse(res.body, {:symbolize_names => true})[:ask].to_i}
    end

    private

    def self.client
      @@client ||= CoincheckClient.new(ENV['COINCHECK_API_KEY'], ENV['COINCHECK_API_SECRET'])
    end
  end
end
