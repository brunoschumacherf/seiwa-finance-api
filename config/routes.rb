Rails.application.routes.draw do
  resources :doctors, only: [:create] do
    get :balance, on: :member
  end
  resources :financial_events, only: [:create]
end