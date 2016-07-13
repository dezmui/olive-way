Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#beta'
  get   '/landing' => 'pages#landing'

  get   '/collections' => 'pages#collections'
  get   '/collection' => 'pages#collection'
  get   '/foundation' => 'pages#foundation'
  get   '/story' => 'pages#story'
  get   '/faq' => 'pages#faq'
  get   '/guarantee' => 'pages#guarantee'
  get   '/how' => 'pages#how'
  get   '/privacy' => 'pages#privacy'
  get   '/ship_return' => 'pages#ship_return'

  get   '/account' => 'accounts#account'
  get   '/hub' => 'accounts#account_hub'

  get   '/profile'  => 'accounts#edit_addresses'
  patch '/profile'  => 'accounts#update_addresses'
  post  '/profile'  => 'accounts#update_addresses'

  get   '/measurements' => 'accounts#edit_measurement'
  patch '/measurements' => 'accounts#update_measurement'
  post  '/measurements' => 'accounts#update_measurement'

  get   '/mens' => 'suits#mens'
  get   '/womens' => 'suits#womens'
  resources :suits, only: [:show]

  resources :accessories, only: [:index, :show]

  resources :orders, only: [:index, :new, :create]
  get   '/checkout' => 'orders#checkout'

  resources :order_objects, only: [:new, :create, :destroy]

  namespace :ambassador do
    resources :ambassadors, only: [:create]
    get '/apply' => 'ambassadors#new'
    get '/thanks' => 'ambassadors#thanks'
  end

  resources :charges, only: [:create]
end
