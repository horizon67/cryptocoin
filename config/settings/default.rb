class Settings
  extend Dry::Configurable

  setting :notify_shooting_up do
    setting :notify_limit, 0.35
  end

  setting :notify_shooting_down do
    setting :notify_limit, -0.35
  end

  setting :notify_best_arbitrage_btc do
    setting :notify_limit, 10000
  end

  setting :order_btc do
    setting :amount, 0.5
    setting :target_profit, 8000
    setting :sell_ex, "Coincheck"
    setting :buy_ex, "Quoine"
  end

  setting :order_btc2 do
    setting :amount, 0.5
    setting :target_profit, 8000
    setting :sell_ex, "Bitflyer"
    setting :buy_ex, "Quoine"
  end

  setting :mex_maker_bot do
    setting :amount, 2500 # USD
  end

  setting :toreten do
    setting :amount, 0.2 # BTC
    setting :leverage_level, 4
  end

  setting :site do
    setting :name, "暗号通貨 開発状況"
    setting :page_title, "暗号通貨一覧"
    setting :page_description, "暗号通貨の最近のコミット数が確認できます。名称での絞り込みや、コミット数などでの並び替えも可能です。"
    setting :page_keywords, "暗号通貨,仮想通過,一覧,開発状況,開発,リポジトリ,プルリク,コミット数,cryptocurrency,
DeFi,BTC,Bitcoin,BCH,NEO,IOT,IOTA,ADA,ETH,Ethereum,LTC,Litecoin,XRP,Ripple,dev activitiy,github,commits count, pull requests count"
    setting :meta do
      setting :ogp do
        setting :type, "website"
        setting :image_path, "http://localhost:3000/images/og.jpg"
      end
    end
  end
end
