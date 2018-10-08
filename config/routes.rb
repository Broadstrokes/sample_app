Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help',      to: 'static_pages#help'
  get '/about',     to: 'static_pages#about'
  get '/contact',   to: 'static_pages#contact'
  
  get 'ccsf_rails/about'
  get 'ccsf_rails/index'
  get 'ccsf_rails/links'
end
