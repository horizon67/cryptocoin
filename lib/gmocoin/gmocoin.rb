require_relative 'gmocoin/version'
require_relative 'gmocoin/http'
require_relative 'gmocoin/configuration'

module Gmocoin
  extend Configuration

  def http_public_client
    Gmocoin::HTTP::Public::Client.new
  end

  def http_private_client(key, secret)
    Gmocoin::HTTP::Private::Client.new(key, secret)
  end

  module_function :http_public_client, :http_private_client
end
