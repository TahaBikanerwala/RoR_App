Rails.application.routes.draw do
  get "account_activations/edit"
  root   "static_pages#home"
  get    "about"     => "static_pages#about"
  get    "help"      => "static_pages#help"
  get    "contact"   => "static_pages#contact"
  get    "signup"    => "users#new"
  get    "login"     => "sessions#new"
  post   "login"     => "sessions#create"
  delete "logout"    => "sessions#destroy"

  resources :users
  resources :account_activations, only: [ :edit ]
  resources :microposts, only: [ :create, :destroy ]
  get "up" => "rails/health#show", as: :rails_health_check
end
