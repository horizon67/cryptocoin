class UpdateRepositoryWorker
  include Sidekiq::Worker

  def perform(coin_id)
		begin
			collector = CountCollector.new(Coin.find(coin_id).main_repository)
			collector.execute!
		rescue => e
			logger.error "#{coin_id} #{e.message}"
		end
  end
end
