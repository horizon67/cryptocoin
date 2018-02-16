class CoinsController < ApplicationController
  def index
    expires_in 3.hour
    @coins = Coin.includes(:repositories).where("repositories.language is not null").references(:repositories)
    render json: @coins, root: false, adapter: :json
  end
end
