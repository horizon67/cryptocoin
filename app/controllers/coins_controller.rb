class CoinsController < ApplicationController
  def index
    expires_in 3.hour
    unless request.from_smartphone?
      @coins = Coin.includes(:repositories).where("repositories.language is not null").references(:repositories)
    else
      @coins = Coin.includes(:repositories).
                    where("repositories.language is not null and repositories.commits_count_for_the_last_month > 0").
                    references(:repositories)
    end
    render json: @coins, root: false, adapter: :json
  end
end
