Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  root 'static_pages#home'
  get '/help',      to: 'static_pages#help'
  get '/about',     to: 'static_pages#about'
  get '/contact',   to: 'static_pages#contact'
  get '/signup',    to: 'users#new'
  post '/signup',   to: 'users#create'

  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end    
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update] # arranges for the RESTful routes
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy] # routes for user relationships
  
  get 'ccsf_rails/about'
  get 'ccsf_rails/index'
  get 'ccsf_rails/links'
end
