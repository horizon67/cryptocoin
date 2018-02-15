class Settings
  extend Dry::Configurable

  setting :site do
    setting :name, "CoinDevActivitiy"
    setting :page_title, "Cryptocurrency Development Activitiy"
    setting :page_description, "Cryptocurrency Development Activitiy. commits count, pull requests count, and more"
    setting :page_keywords, "cryptocurrency,coin,development,dev activitiy,github,commits count, pull requests count"
    setting :meta do
      setting :ogp do
        setting :type, "website"
        setting :image_path, "https://coindeva.io/images/og.jpg"
      end
    end
  end
end
