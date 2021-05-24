require_relative 'bitfinex/version'
require_relative 'bitfinex/http'
require_relative 'bitfinex/configuration'

module Bitfinex
  extend Configuration

  def http_public_client
    Bitfinex::HTTP::Public::Client.new
  end

  def http_private_client(key, secret)
    Bitfinex::HTTP::Private::Client.new(key, secret)
  end

  module_function :http_public_client, :http_private_client
end
