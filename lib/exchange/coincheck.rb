module Exchange
  class Coincheck

    def initialize(key, secret)
      @client = CoincheckClient.new(key, secret)
    end

    def market_buy(amount)
      @client.create_orders(market_buy_amount: (ticker[:ask] * amount).floor, order_type: "market_buy")
    end

    def market_sell(amount)
      @client.create_orders(amount: amount, order_type: "market_sell")
    end

    def balances
      res = @client.read_balance
      {jpy: JSON.parse(res.body, {:symbolize_names => true})[:jpy].to_f,
       btc: JSON.parse(res.body, {:symbolize_names => true})[:btc].to_f}
    end

    def ticker
      res = @client.read_ticker
      {bid: JSON.parse(res.body, {:symbolize_names => true})[:bid].to_i,
       ask: JSON.parse(res.body, {:symbolize_names => true})[:ask].to_i}
    end
  end
end
