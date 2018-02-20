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

  setting :order_btc do
    setting :amount, 0.5
    setting :target_profit, 8000
  end

  setting :site do
    setting :name, "CoinDevActivitiy"
    setting :page_title, "Cryptocurrency Development Activitiy"
    setting :page_description, "Cryptocurrency Development Activitiy. commits count, pull requests count, and more"
    setting :page_keywords, "cryptocurrency,coin,development,dev activitiy,github,commits count, pull requests count"
    setting :meta do
      setting :ogp do
        setting :type, "website"
        setting :image_path, "http://localhost:3000/images/og.jpg"
      end
    end
  end
end
