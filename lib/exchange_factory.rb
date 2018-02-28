class ExchangeFactory
  def self.create(exchange, key, secret)
    "Exchange::#{exchange.classify}".constantize.new(key, secret)
  rescue => e
    raise InvalidExchangeNameError.new("invalid Exchange: #{exchange}")
  end
end
