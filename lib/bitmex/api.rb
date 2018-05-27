require 'rest-client'
require 'json'
require 'base64'
require 'byebug'

module Bitmex
  class API
    attr_reader :key,
                :secret,
                :url

    def initialize(key:, secret:, url: 'https://www.bitmex.com')
      @key = key
      @secret = secret
      @url = url
    end

    def order
      get("/api/v1/order", { params: {symbol: "XBTUSD"}})
    end

    def position
      get("/api/v1/position", { params: {filter: '{"symbol": "XBTUSD"}'}})
    end

    def close_position
      opts = {
        symbol: "XBTUSD"
      }
      order = post('/api/v1//order/closePosition', opts)
      order
    end

    def cancel_order(id)
    end

    def create_order(side:, size:, price:, order_type:)
      opts = {
        symbol: "XBTUSD",
        side: side,
        orderQty: size.to_f.to_s,
        price: price.to_f.to_s,
        ordType: order_type,
        execInst: "ParticipateDoNotInitiate"
      }
      order = post('/api/v1/order', opts)

      if !order['orderID']
        error ||= order
        raise Bitmex::CreateOrderException.new(error)
      end

      order
    rescue => e
      raise Bitmex::CreateOrderException.new(e.message)
    end

    # private

    def signature(timestamp, method, path, body)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, method + path + timestamp + body)
    end

    def get(path, opts = {})
      uri = URI.parse("#{@url}#{path}")
      uri.query = URI.encode_www_form(opts[:params]) if opts[:params]
      response = RestClient.get(uri.to_s, auth_headers("GET", uri.request_uri, ""))

      if !opts[:skip_json]
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def post(path, payload, opts = {})
      data = JSON.unparse(payload)
      response = RestClient.post("#{@url}#{path}", data, auth_headers("POST", path, data))

      if !opts[:skip_json]
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def put(path, opts = {})
      response = RestClient.put("#{@url}#{path}", auth_headers(path))

      if !opts[:skip_json]
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def delete(path, opts = {})
      response = RestClient.delete("#{@url}#{path}", auth_headers(path))

      if !opts[:skip_json]
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def auth_headers(method, path, body)
      timestamp = 10.minutes.since.to_i.to_s
      sign = signature(timestamp, method, path, body)

      {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'X-Requested-With' => 'XMLHttpRequest',
        'api-expires' => timestamp,
        'api-key' => @key,
        'api-signature' => sign
      }
    end
  end
  class CreateOrderException < RuntimeError; end
  class CancelOrderException < RuntimeError; end
end
