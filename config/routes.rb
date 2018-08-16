Rails.application.routes.draw do
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  resources :test_suits do
    resources :test_cases
  end
  get 'static_pages/home'
  root "test_suits#index"
end
