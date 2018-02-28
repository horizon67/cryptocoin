module Exchange
  class Quoine

    PRODUCT_ID = 5

    def initialize(key, secret)
      @client = Quoinex::API.new(key: key, secret: secret)
    end

    def market_buy(amount)
      @client.create_order(side: :buy, size: amount, price: nil, product_id: Exchange::Quoine::PRODUCT_ID, order_type: "market")
    end

    def market_sell(amount)
      @client.create_order(side: :sell, size: amount, price: nil, product_id: Exchange::Quoine::PRODUCT_ID, order_type: "market")
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
