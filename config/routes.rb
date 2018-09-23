Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/contact'
  
  get 'ccsf_rails/about'
  get 'ccsf_rails/index'
  get 'ccsf_rails/links'
end
