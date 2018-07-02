class MexPredictPriceWorker
  include Sidekiq::Worker

  def perform(*args)
    conn = Faraday::Connection.new
    conn.options.timeout = 600
    res = conn.get "http://127.0.0.1:5000/predict_price"
    hash = JSON.parse(res.body, {:symbolize_names => true})
    bitmex = Exchange::Bitmex.new(ENV["BITMEX_API_KEY"], ENV["BITMEX_API_SECRET"])
    PredictPrice.create!(price: hash[:predict_price].to_f, candle_term: "1h", last_price: bitmex.ticker[:last])
  end
end
