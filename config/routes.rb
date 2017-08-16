Rails.application.routes.draw do

  mount Shoppe::Engine => "/shoppe"
  root to: 'about#news'
  get '/store', to: 'products#index'
  get '/about', to: 'about#me'
  get '/videos', to: 'about#videos'
  get '/support', to: 'about#support'
  get '/news', to: 'about#news'

  get "product/:permalink", to: "products#show", as: "product"
  get "product/:permalink/variant/:id", to: 'products#variant'
  post "product/:permalink", to: "products#buy", as: "buy"

  delete "basket", to: "orders#destroy"
  get "basket", to: "orders#show"
  patch 'basket', to: 'orders#remove_item', as: 'remove_item'

  match "checkout", to: "orders#checkout", as: "checkout", via: [:get, :patch]
  match "checkout/paypal", to: "orders#paypal", as: "checkout_paypal", via: [:get, :post]
  match "checkout/payment", to: "orders#payment", as: "checkout_payment", via: [:get, :post]
  match "checkout/confirm", to: "orders#confirmation", as: "checkout_confirmation", via: [:get, :post]

  get "checkout/paypal", to: "orders#paypal"
end
