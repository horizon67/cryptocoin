Sidekiq::Logging.logger.level = Logger::DEBUG
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:16379/12' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localohost:16379/12' }
end
