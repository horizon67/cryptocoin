class Settings
  extend Dry::Configurable

  setting :notify_shooting_up do
    setting :notify_limit, 0.35
  end
  setting :notify_shooting_down do
    setting :notify_limit, -0.35
  end
  setting :notify_best_arbitrage_btc do
    setting :notify_limit, 20000
  end
end
