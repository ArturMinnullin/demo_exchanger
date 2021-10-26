Rails.application.routes.draw do
  resources :transactions, only: %w[new create]

  root to: 'transactions#new'
end
