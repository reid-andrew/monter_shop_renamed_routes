Rails.application.routes.draw do
  root "welcome#index"

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  patch "/cart/:item_id", to: "cart#update"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"
  patch "/orders/:order_id", to:"orders#update"

  get "/register", to: "users#new"
  post "/register", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  get "/profile", to: "profile#index"
  get "/profile/:id/password", to: "passwords#edit"
  get "/profile/:id/edit", to: "profile#edit"
  patch "/profile/:id/edit", to: "profile#update"
  patch "/profile/:id/password", to: "passwords#update"

  get "/item_order/:item_order_id", to: "item_orders#show"
  patch "/item_orders/:item_order_id", to: "item_orders#update"

  namespace :profile do
    get "/", to: "profile#index"
    get "/", to: "cart#index"
    get "/orders", to: "orders#index"
    get "/orders/:order_id", to: "orders#show"
  end

  namespace :merchant do
    get "/", to: "dashboard#index"
    get "items", to: "items#index"
    patch "items/:id", to: "items#update"
    delete "items/:id", to: "items#destroy"
    get "items/new", to: "items#new"
    post "items", to: "items#create"
  end

  namespace :admin do
    get "/", to: "dashboard#index"
    get "/merchants/:id", to: "merchants#show"
    get "/profile/:profile_id", to: "profile#show"
    patch "/orders/:order_id", to: "orders#update"

  end
end
