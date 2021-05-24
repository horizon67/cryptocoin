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

      nonce = (Time.now.to_f * 1000).to_i.to_s
      path = env[:url].path + (env[:url].query ? '?' + env[:url].query : '')
      body = env[:body] || ''
      payload = "/api#{path}#{nonce}#{body}"
      env[:request_headers]['Content-Type'] = 'application/json'
      env[:request_headers]['bfx-nonce'] = nonce
      env[:request_headers]['bfx-apikey'] = @key
      env[:request_headers]['bfx-signature'] = OpenSSL::HMAC.hexdigest('sha384', @secret, payload)
      @app.call env
    end
  end
end
