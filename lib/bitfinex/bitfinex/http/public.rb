module Bitfinex
  module HTTP
    module Public
      class Client
        def initialize
          @connection = Connection.new(nil, nil)
        end

        def ticker(options = {})
        end
      end
    end
  end
end
