Rails.application.routes.draw do
  resources :doctors, only: [:create] do
    get :balance, on: :member
  end
  resources :financial_events, only: [:create]

  if defined?(Rswag::Api) && defined?(Rswag::Ui)
    mount Rswag::Api::Engine => '/api-docs'
    mount Rswag::Ui::Engine => '/api-docs'
  else
    get '/api-docs', to: 'swagger#index'
    get '/api-docs/v1/swagger.yaml', to: 'swagger#spec'
  end
end