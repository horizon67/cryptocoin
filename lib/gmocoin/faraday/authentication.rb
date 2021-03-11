require 'faraday'

module FaradayMiddleware
  class Authentication < Faraday::Middleware

    def initialize(app, key, secret)
      super(app)
      @key = key
      @secret = secret
    end

    def call(env)
      return @app.call(env) if @key.nil? || @secret.nil?

      timestamp = DateTime.now.strftime('%Q')
      method = env[:method].to_s.upcase
      path = env[:url].path.gsub(/private\//, '') + (env[:url].query ? '?' + env[:url].query : '')
      body = env[:body] || ''
      text = timestamp + method + path + body
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, @secret, text)
      env[:request_headers]['API-TIMESTAMP'] = timestamp
      env[:request_headers]['API-KEY'] = @key if @key
      env[:request_headers]['API-SIGN'] = signature
      @app.call env
    end
  end
end
