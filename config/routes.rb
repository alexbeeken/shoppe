Rails.application.routes.draw do

  mount Shoppe::Engine => "/shoppe"
  root to: 'products#index'
  get '/merch', to: 'products#index'

  get "product/:permalink", to: "products#show", as: "product"
  post "product/:permalink", to: "products#buy", as: "buy"

  delete "basket", to: "orders#destroy"
  get "basket", to: "orders#show"
  patch 'basket', to: 'orders#remove_item', as: 'remove_item'
  post 'checkout/shipping_form', to: 'orders#shipping_form', as: 'shipping_form'

  match "checkout", to: "orders#checkout", as: "checkout", via: [:get, :patch]
  match "checkout/paypal", to: "orders#paypal", as: "checkout_paypal", via: [:get, :patch]
  match "checkout/payment", to: "orders#payment", as: "checkout_payment", via: [:get, :post]
  match "checkout/confirm", to: "orders#confirmation", as: "checkout_confirmation", via: [:get, :post]

  get "checkout/paypal", to: "orders#paypal"
end
