module Bitfinex
  module HTTP
    module Private
      class Client
        def initialize(key, secret)
          @connection = Connection.new(key, secret)
        end

        def order_history
          @connection.post('/v2/auth/r/orders/tBTCUSD/hist', limit: 25).body
        end

        def create_order(symbol, type, amount, options = {})
          @connection.post('/v2/auth/w/order/submit', { symbol: symbol,
                                                        type: type,
                                                        amount: amount.to_s}.merge(options)).body
        end
      end
    end
  end
end
