Rails.application.routes.draw do
  resources :transactions, only: %w[new create show]

  root to: 'transactions#new'
end
