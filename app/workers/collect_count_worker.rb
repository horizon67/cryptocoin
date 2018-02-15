class CollectCountWorker
  include Sidekiq::Worker

  def perform(*args)
    Coin.find_each do |coin|
      UpdateRepositoryWorker.perform_async(coin.id) if coin.main_repository.presennt?
    end
  end
end
