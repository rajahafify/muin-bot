Rails.application.routes.draw do
  resources :users
  get 'pages/support'

  get 'pages/privacy'

  get 'pages/terms'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Messenger::Bot::Space => "/webhooks/facebook/"
end
