class Settings
  extend Dry::Configurable

  setting :notify_shooting_up do
    setting :notify_limit, 0.35
  end

  setting :notify_shooting_down do
    setting :notify_limit, -0.35
  end

  setting :notify_best_arbitrage_btc do
    setting :notify_limit, 30000
  end

  setting :order_btc do
    setting :amount, 0.25
    setting :target_profit, 50000
    setting :sell_ex, "Coincheck"
    setting :buy_ex, "Zaif"
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
    setting :name, "仮想通貨（暗号資産） 開発状況"
    setting :page_title, "仮想通貨（暗号資産）一覧"
    setting :page_description, "仮想通貨（暗号資産）の最近のコミット数が確認できます。名称での絞り込みや、コミット数などでの並び替えも可能です。"
    setting :page_keywords, "暗号資産,仮想通貨,ランキング,一覧,コミット数,開発,リポジトリ,プルリク,ビットコイン,イーサリアム,リップル,crypto,currency,DeFi,BTC,Bitcoin,BCH,NEO,IOT,IOTA,ADA,ETH,Ethereum,LTC,Litecoin,Cosmos,Polkadot,XRP,Ripple,github,PR"
    setting :meta do
      setting :ogp do
        setting :type, "website"
        setting :image_path, "http://localhost:3000/images/og.jpg"
      end
    end
  end
end
