class Repository < ApplicationRecord
  belongs_to :coin
  REPOSITORY_URL_BASE = "https://github.com".freeze
end
