Rails.application.routes.draw do
  get 'ccsf_rails/index'

  get 'ccsf_rails/links'

  get 'ccsf_rails/about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#hello'
end
