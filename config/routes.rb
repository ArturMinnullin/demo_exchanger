# frozen_string_literal: true

Rails.application.routes.draw do
  resources :transactions, only: %w[new create show]

  namespace :admin do
    resources :transactions, only: :index
  end

  root to: 'transactions#new'
end
