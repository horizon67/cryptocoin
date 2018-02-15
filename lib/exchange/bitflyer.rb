module Exchange
  class Bitflyer
    def self.market_buy(amount)
      client.send_child_order(child_order_type: "MARKET", side: "BUY", size: amount)
    end

    def self.market_sell(amount)
      client.send_child_order(child_order_type: "MARKET", side: "SELL", size: amount)
    end

    def self.balances
      balances = client.balance
      {jpy: balances.find {|b| b["currency_code"] == "JPY"}["amount"],
       btc: balances.find {|b| b["currency_code"] == "BTC"}["amount"]}
    end

    def self.ticker
      res = public_client.ticker
      {bid: res["best_bid"].to_i,
       ask: res["best_ask"].to_i}
    end

    private

    def self.client
      @@client ||= ::Bitflyer.http_private_client(ENV['BITFLYER_API_KEY'], ENV['BITFLYER_API_SECRET']) 
    end

    def self.public_client
      ::Bitflyer.http_public_client
    end
  end
end
