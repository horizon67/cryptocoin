module Exchange
  class Bitmex

    def initialize(key, secret)
      @client = ::Bitmex::API.new(key: key, secret: secret)
    end

    # amount: USD
    def limit_buy(amount, price)
      @client.create_order(side: "Buy", size: amount, price: price, order_type: "Limit")
    end

    def position
      @client.position
    end

    def get_order
      @client.order
    end

    def get_open_orders
      @client.open_orders
    end

    def close_position
      @client.close_position
    end

    def cancel_orders
      @client.cancel_orders
    end

    def cancel_order(id, cid)
      @client.cancel_order(id, cid)
    end

    # amount: USD
    def limit_sell(amount, price)
      @client.create_order(side: "Sell", size: amount, price: price, order_type: "Limit")
    end

    def balances
      balances = @client.balances
      {jpy: balances.find {|b| b["currency"] == "JPY"}["balance"],
       btc: balances.find {|b| b["currency"] == "BTC"}["balance"]}
    end

    def ticker
      res = Faraday.get "#{@client.url}/products/#{Exchange::Quoine::PRODUCT_ID}"
      {bid: JSON.parse(res.body, {:symbolize_names => true})[:market_bid].to_i,
       ask: JSON.parse(res.body, {:symbolize_names => true})[:market_ask].to_i}
    end
  end
end
