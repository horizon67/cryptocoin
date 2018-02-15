module Exchange
  class Bitbank
    def self.market_buy(amount)
      client.create_order("btc_jpy", amount, nil, "buy", "market")
    end

    def self.market_sell(amount)
      client.create_order("btc_jpy", amount, nil, "sell", "market")
    end

    def self.balances
      json_balances = JSON.parse(client.read_balance, {:symbolize_names => true})[:data][:assets]
      {jpy: json_balances.find {|b| b[:asset] == "jpy"}[:onhand_amount],
       btc: json_balances.find {|b| b[:asset] == "btc"}[:onhand_amount]}
    end

    def self.ticker
      res = client.read_ticker("btc_jpy")
      {bid: JSON.parse(res.body, {:symbolize_names => true})[:data][:buy].to_i,
       ask: JSON.parse(res.body, {:symbolize_names => true})[:data][:sell].to_i}
    end

    private

    def self.client
      @@client ||= Bitbankcc.new(ENV["BITBANK_API_KEY"], ENV["BITBANK_API_SECRET"])
    end
  end
end
