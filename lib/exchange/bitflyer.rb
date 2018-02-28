module Exchange
  class Bitflyer

    def initialize(key, secret)
      @private_client = ::Bitflyer.http_private_client(key, secret)
      @public_client = ::Bitflyer.http_public_client
    end

    def market_buy(amount)
      @private_client.send_child_order(child_order_type: "MARKET", side: "BUY", size: amount)
    end

    def market_sell(amount)
      @private_client.send_child_order(child_order_type: "MARKET", side: "SELL", size: amount)
    end

    def balances
      balances = @private_client.balance
      {jpy: balances.find {|b| b["currency_code"] == "JPY"}["amount"],
       btc: balances.find {|b| b["currency_code"] == "BTC"}["amount"]}
    end

    def ticker
      res = @public_client.ticker
      {bid: res["best_bid"].to_i,
       ask: res["best_ask"].to_i}
    end
  end
end
