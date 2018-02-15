class CoinsController < ApplicationController
  def index
    expires_in 10.hour
    @coins = Coin.includes(:repositories)
    render json: @coins, root: false, adapter: :json
  end
end
