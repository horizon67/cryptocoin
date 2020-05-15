module Exchange
  class Quoine

    PRODUCT_ID = 5

    def initialize(key, secret)
      @client = Quoinex::API.new(key: key, secret: secret)
    end

    def spot_market_buy(amount)
      @client.create_order(side: :buy, size: amount, price: nil, product_id: Exchange::Quoine::PRODUCT_ID, order_type: "market")
    end

    def leverage_market_buy(amount, leverage_level)
      @client.create_order(side: :buy, size: amount, price: nil,
                           product_id: Exchange::Quoine::PRODUCT_ID,
                           order_type: 'market', margin_type: 'cross',
                           leverage_level: leverage_level)
    end

    def spot_market_sell(amount)
      @client.create_order(side: :sell, size: amount, price: nil, product_id: Exchange::Quoine::PRODUCT_ID, order_type: "market")
    end

    def leverage_market_sell(amount, leverage_level)
      @client.create_order(side: :sell, size: amount, price: nil,
                           product_id: Exchange::Quoine::PRODUCT_ID,
                           order_type: 'market', margin_type: 'cross',
                           leverage_level: leverage_level)
    end

    def trades(opts = {})
      @client.trades(opts)
    end

    def trade_close_all
      @client.trade_close_all
    end

    def fiat_accounts
      @client.fiat_accounts
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
