module Gmocoin
  module HTTP
    # @see https://api.coin.z.com/docs/?ruby#private-api
    module Private
      class Client
        def initialize(key, secret)
          @connection = Connection.new(key, secret)
        end

        # @see https://api.coin.z.com/docs/?ruby#assets
        def assets
          @connection.get('/private/v1/account/assets').body
        end

        # @see https://api.coin.z.com/docs/?ruby#order
        def create_order(symbol, side, execution_type, size, options = {})
          @connection.post('/private/v1/order', { symbol: symbol,
                                                  side: side,
                                                  executionType: execution_type,
                                                  size: size}.merge(options)).body
        end
      end
    end
  end
end
