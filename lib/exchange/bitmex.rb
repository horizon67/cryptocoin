module Exchange
  class Bitmex

    def initialize(key, secret)
      @private_client = ::Bitmex.http_private_client(key, secret)
      @public_client = ::Bitmex.http_public_client
    end

    # amount: USD
    def limit_buy(amount, price)
      @private_client.create_order("XBTUSD", {side: "Buy", orderQty: amount.to_f.to_s, price: price, execInst: "ParticipateDoNotInitiate", ordType: "Limit"})
    end

    # amount: USD
    def limit_sell(amount, price)
      @private_client.create_order("XBTUSD", {side: "Sell", orderQty: amount.to_f.to_s, price: price, execInst: "ParticipateDoNotInitiate", ordType: "Limit"})
    end

    # amount: USD
    def market_buy(amount)
      @private_client.create_order("XBTUSD", {side: "Buy", orderQty: amount.to_f.to_s, price: price, execInst: "ParticipateDoNotInitiate", ordType: "Market"})
    end

    # amount: USD
    def market_sell(amount)
      @private_client.create_order("XBTUSD", {side: "Sell", orderQty: amount.to_f.to_s, price: price, execInst: "ParticipateDoNotInitiate", ordType: "Market"})
    end

    def position
      @private_client.position({ params: {filter: '{"symbol": "XBTUSD"}'}})
    end

    def get_order
      @client.order({ params: {symbol: "XBTUSD"}})
    end

    def get_open_orders
      @client.order({ params: {filter: '{"open": true}'}})
    end

    def close_position
      @client.close_position("XBTUSD")
    end

    def cancel_orders
      @client.cancel_orders
    end

    def cancel_order(id, cid)
      @client.cancel_order(id, cid)
    end

    def balances
    end

    def ticker
      hash = @public_client.instrument_active.find {|h| h[:symbol] == "XBTUSD"}
      {bid: hash[:bidPrice].to_i,
       ask: hash[:askPrice].to_i,
       last: hash[:lastPrice].to_i}
    end
  end
end
