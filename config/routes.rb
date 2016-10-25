Rails.application.routes.draw do

  mount Shoppe::Engine => "/shoppe"
  get '/merch', to: 'products#index'

  get "product/:permalink", to: "products#show", as: "product"
  post "product/:permalink", to: "products#buy", as: "buy"
  root to: "products#index"

  delete "basket", to: "orders#destroy"
  get "basket", to: "orders#show"

  match "checkout", to: "orders#checkout", as: "checkout", via: [:get, :patch]
  match "checkout/pay", to: "orders#payment", as: "checkout_payment", via: [:get, :post]
  match "checkout/confirm", to: "orders#confirmation", as: "checkout_confirmation", via: [:get, :post]

  get "checkout/paypal", to: "orders#paypal"
end
