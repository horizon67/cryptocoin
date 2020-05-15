require 'rest-client'
require 'json'
require 'base64'
require 'byebug'
require 'jwt'
require 'quoinex/exceptions'

# @see https://github.com/heelhook/quoinex/blob/master/lib/quoinex/quoinex.rb
module Quoinex
  class API
    attr_reader :key,
                :secret,
                :url

    def initialize(key:, secret:, url: 'https://api.liquid.com')
      @key = key
      @secret = secret
      @url = url
    end

    def balances
      get('/accounts/balance')
    end

    def fiat_accounts
      get('/fiat_accounts')
    end

    def order(id)
      get("/orders/#{id}")
    end

    def orders
      get('/orders')
    end

    def cancel_order(id)
      status = put("/orders/#{id}/cancel")

      if status['responseStatus'] && status['responseStatus']['errorCode']
        error = status['responseStatus']['message']
        error ||= status['responseStatus']
        raise Quoinex::CancelOrderException.new(error)
      end

      status
    rescue => e
      raise Quoinex::CancelOrderException.new(e.message)
    end

    def create_order(side:, size:, price:, product_id:, order_type:, margin_type:, leverage_level:)
      opts = {
        margin_type: margin_type,
        leverage_level: leverage_level,
        order_type: order_type,
        product_id: product_id,
        side: side,
        quantity: size.to_f.to_s,
        price: price.to_f.to_s,
        funding_currency: 'JPY',
        order_direction: 'one_direction'
      }.compact
      order = post('/orders', opts)

      if !order['id']
        error ||= order
        raise Quoinex::CreateOrderException.new(error)
      end

      order
    rescue => e
      raise Quoinex::CreateOrderException.new(e.message)
    end

    def trades(opts = {})
      get('/trades', opts)
    end

    def trade_close_all(opts = {})
      put('/trades/close_all', opts)
    end

    private

    def signature(path)
      auth_payload = {
        path: path,
        nonce: DateTime.now.strftime('%Q'),
        token_id: @key
      }

      JWT.encode(auth_payload, @secret, 'HS256')
    end

    def get(path, opts = {})
      uri = URI.parse("#{@url}#{path}")
      uri.query = URI.encode_www_form(opts) if opts.present?

      response = RestClient.get(uri.to_s, auth_headers(uri.request_uri))

      if !opts[:skip_json]
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def post(path, payload, opts = {})
      data = JSON.unparse(payload)
      response = RestClient.post("#{@url}#{path}", data, auth_headers(path))

      if !opts[:skip_json]
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def put(path, payload, opts = {})
      data = JSON.unparse(payload)
      response = RestClient.put("#{@url}#{path}", data,  auth_headers(path))

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

    def auth_headers(path)
      sign = signature(path)

      {
        'Content-Type' => 'application/json',
        'X-Quoine-API-Version' => '2',
        'X-Quoine-Auth' => sign,
      }
    end
  end
end
