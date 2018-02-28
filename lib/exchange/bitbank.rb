module Exchange
  class Bitbank

    def initialize(key, secret)
      @client = Bitbankcc.new(key, secret)
    end

    def market_buy(amount)
      @client.create_order("btc_jpy", amount, nil, "buy", "market")
    end

    def market_sell(amount)
      @client.create_order("btc_jpy", amount, nil, "sell", "market")
    end

    def balances
      json_balances = JSON.parse(@client.read_balance, {:symbolize_names => true})[:data][:assets]
      {jpy: json_balances.find {|b| b[:asset] == "jpy"}[:onhand_amount],
       btc: json_balances.find {|b| b[:asset] == "btc"}[:onhand_amount]}
    end

    def ticker
      res = @client.read_ticker("btc_jpy")
      {bid: JSON.parse(res.body, {:symbolize_names => true})[:data][:buy].to_i,
       ask: JSON.parse(res.body, {:symbolize_names => true})[:data][:sell].to_i}
    end
  end
end
