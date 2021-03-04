module Gmocoin
  module HTTP
    # @see https://api.coin.z.com/docs/?ruby#public-api
    module Public
      class Client
        def initialize
          @connection = Connection.new(nil, nil)
        end

        # @see https://api.coin.z.com/docs/?ruby#status
        def status
          @connection.get('/public/v1/status').body
        end

        # @see https://api.coin.z.com/docs/?ruby#ticker
        def ticker(options = {})
          @connection.get('/public/v1/ticker', options).body
        end
      end
    end
  end
end
