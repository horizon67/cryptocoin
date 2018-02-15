class Coin < ApplicationRecord
  has_many :repositories, dependent: :destroy

  def main_repository
    self.repositories.first
  end

  def main_repository_url
    "#{Repository::REPOSITORY_URL_BASE}/#{owner}/#{main_repository&.name}"
  end
end
