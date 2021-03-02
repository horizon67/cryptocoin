# RailsSettings Model
class AppConfig < RailsSettings::Base
  cache_prefix { "v1" }

  field :arb_amount, type: :float, default: 0.254
  field :arb_target_profit, type: :integer, default: 55000
  field :arb_sell_ex, type: :string, default: 'Bitflyer'
  field :arb_buy_ex, type: :string, default: 'Zaif'
end
