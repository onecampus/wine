Rails.application.routes.draw do

  resources :wx_menus

  root 'site#index'

  # product cat
  get 'customer/cats' => 'site#index_cats'
  get 'customer/cats/:cid/products' => 'site#index_cat_products'

  # customer shipaddress
  get 'customer/shipaddresses/new' => 'site#new_ship_address'
  match 'customer/shipaddresses/create', to: 'site#create_ship_address', via: :post
  match 'customer/shipaddresses/create/json', to: 'site#create_ship_address_via_ajax', via: :post
  get 'customer/shipaddresses' => 'site#index_ship_address'

  # product
  get 'customer/products/:id/show' => 'site#show_product'

  # product comment
  get 'customer/products/:id/comments/new' => 'site#new_comment'
  match 'customer/products/:id/comments/create', to: 'site#create_comment', via: :post
  get 'customer/products/:id/comments' => 'site#index_comments'
  get 'customer/products/search' => 'site#index_search_result'

  # order
  match 'customer/invoice/create/json', to: 'site#create_invoice_via_ajax', via: :post
  get 'customer/orders/settlement' => 'site#order_settlement'
  match 'customer/orders/create', to: 'site#create_order', via: :post

  get 'customer/commission' => 'site#commission'

  # user center
  get 'customer/cart' => 'site#index_shopping_cart'
  get 'customer/users/center' => 'site#user_center'
  get 'customer/users/wait/ship' => 'site#index_wait_ship'
  get 'customer/users/wait/pay' => 'site#index_wait_pay'
  get 'customer/users/wait/receive' => 'site#index_wait_receive'
  get 'customer/users/orders/history' => 'site#index_order_history'
  get 'customer/users/vipcard' => 'site#show_vip_card'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # activity prize
  get 'customer/big/wheel' => 'site#big_wheel'
  match 'customer/big/wheel', to: 'site#big_wheel_ajax', via: :post
  get 'customer/scratch/off' => 'site#scratch_off'
  match 'customer/scratch/off', to: 'site#scratch_off_ajax', via: :post

  scope '/admin' do

    resources :prize_user_numbers
    resources :prize_users
    resources :prize_configs
    resources :prize_acts

    resources :integrals
    resources :vritualcards
    resources :shipaddresses

    resources :product_orders
    resources :orders
    get 'orders/wait/sure' => 'orders#index_orders_unsure'
    get 'orders/wait/ship' => 'orders#index_orders_wait_ship'
    get 'orders/already/ship' => 'orders#index_orders_already_ship'
    get 'orders/already/receive' => 'orders#index_orders_already_receive'
    get 'orders/already/ok' => 'orders#index_orders_already_ok'
    get 'orders/wait/back' => 'orders#index_orders_back'
    get 'orders/already/cancel' => 'orders#index_orders_canceled'

    resources :invoices
    resources :products
    resources :inventories
    resources :comments
    resources :tags

    resources :roles
    resources :users
    resources :profiles

    resources :cats do
      collection do
        get :nested_options
        get :manage
        get :node_manage
        get :expand

        post :rebuild
        post :expand_node
      end
    end
  end

  get 'weixin' => 'weixin#show'
  match 'weixin', to: 'weixin#create', via: :post
end
