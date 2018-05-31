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

    def open_orders
      get("/api/v1/order", { params: {filter: '{"open": true}'} })
    end

    def position
      get("/api/v1/position", { params: {filter: '{"symbol": "XBTUSD"}'} })
    end

    def close_position
      opts = {
        symbol: "XBTUSD"
      }
      order = post('/api/v1//order/closePosition', opts)
      order
    end

    def cancel_order(id, cid)
      payload = {
        orderID: id,
        clOrdID: cid
      }
      delete('/api/v1/order/all', payload)
    end

    def cancel_orders
      delete('/api/v1/order/all', {})
    end

    def create_order(side:, size:, price:, order_type:)
      payload = {
        symbol: "XBTUSD",
        side: side,
        orderQty: size.to_f.to_s,
        price: price.to_f.to_s,
        execInst: "ParticipateDoNotInitiate",
        ordType: order_type
      }
      order = post('/api/v1/order', payload)

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

      client = Faraday.new(:url => uri.to_s)
      response = client.get do |req|
        req.headers = auth_headers("GET", uri.request_uri, "")
      end

      if !opts[:skip_json]
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def post(path, payload, opts = {})
      data = JSON.unparse(payload)

      client = Faraday.new(:url => @url)
      response = client.post do |req|
        req.url path
        req.headers = auth_headers("POST", path, data) 
        req.body = data
      end

      if !opts[:skip_json]
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def delete(path, payload, opts = {})
      data = JSON.unparse(payload)

      client = Faraday.new(:url => @url)
      response = client.delete do |req|
        req.url path
        req.headers = auth_headers("DELETE", path, data) 
        req.body = data
      end

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
