Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "activities#index"
  scope :api, { format: 'json' } do
    resources :coins, only: :index
  end
end
