class CoinsController < ApplicationController
  def index
    expires_in 10.hour
    @coins = Coin.joins(:repositories).where("repositories.language is not null")
    render json: @coins, root: false, adapter: :json
  end
end
