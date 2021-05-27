# require 'bitfinex'
require_relative 'http/public'
require_relative 'http/private'
# require_relative '../faraday'
# require 'faraday_middleware'
Dir[File.expand_path('../../faraday/*.rb', __FILE__)].each{|f| require f}

module Bitfinex
  module HTTP
    class Connection
      extend Forwardable

      def_delegators :@connection, :get, :post, :delete

      def initialize(key, secret)
        @connection = Faraday::Connection.new(url: Bitfinex.url) do |f|
          f.request :json
          f.response :json, :parser_options => { :symbolize_names => true }
          f.use FaradayMiddleware::Authentication, key, secret
          f.use FaradayMiddleware::RaiseHttpException
          f.use FaradayMiddleware::LoudLogger
          f.adapter Bitfinex.adapter
        end
      end
    end
  end
end
