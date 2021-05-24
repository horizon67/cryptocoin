require 'faraday'
require File.expand_path('../version', __FILE__)

module Bitfinex
  module Configuration
    VALID_OPTIONS_KEYS = [
      :adapter,
      :url,
      :user_agent,
      :loud_logger
    ].freeze

    DEFAULT_ADAPTER = Faraday.default_adapter
    DEFAULT_URL = 'https://api.bitfinex.com'.freeze
    DEFAULT_USER_AGENT = "Bitfinex Ruby Gem #{Bitfinex::VERSION}".freeze
    DEFAULT_LOUD_LOGGER = false

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def reset
      self.adapter = DEFAULT_ADAPTER
      self.url = DEFAULT_URL
      self.user_agent = DEFAULT_USER_AGENT
      self.loud_logger = DEFAULT_LOUD_LOGGER
    end
  end
end
