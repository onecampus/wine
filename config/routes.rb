Rails.application.routes.draw do

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

  # group
  get 'customer/groups/:id/show' => 'site#show_group'
  get 'customer/groups_and_seckills' => 'site#index_groups_seckills'
  get 'customer/seckills/:id/show' => 'site#show_seckill'


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

  # withdraw
  get 'customer/withdraws/new' => 'site#new_withdraw'
  get 'customer/withdraws' => 'site#index_withdraws'
  match 'customer/withdraws/create', to: 'site#create_withdraw', via: :post

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

    get 'commissions/year/index' => 'commissions#year_compute_index'
    get 'commissions/year/compute' => 'commissions#year_compute'

    resources :commissions

    resources :withdraws
    get 'withdraws/:id/ok' => 'withdraws#ok_withdraw'

    resources :site_configs
    get 'site_configs/customer/index/imgs/edit' => 'site_configs#edit_index_imgs'
    get 'site_configs/customer/index/imgs' => 'site_configs#show_index_imgs'
    match 'site_configs/customer/index/imgs/update', to: 'site_configs#update_index_imgs', via: :post

    resources :seckill_orders
    resources :seckills

    resources :group_orders
    resources :groups

    match 'wx_menus/name/create/json', to: 'wx_menus#create_menu_name', via: :post
    match 'wx_menus/update/json', to: 'wx_menus#update_via_json', via: :post
    get 'weixin/menus/create/json' => 'wx_menus#create_weixin_menu'
    get 'wx_menus/:id/del/json' => 'wx_menus#destroy_via_ajax'
    match 'wx_menus/create/json', to: 'wx_menus#create_via_ajax', via: :post
    match 'wx_menus/:id/action/set', to: 'wx_menus#set_menu_action', via: :post
    match 'wx_menus/images/upload', to: 'wx_menus#upload_img', via: :post
    resources :wx_menus

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
    get 'orders/:id/sure' => 'orders#sure_order', as: :sure_order
    get 'orders/wait/ship' => 'orders#index_orders_wait_ship'
    match 'orders/:id/express/add', to: 'orders#add_order_express', via: :post
    get 'orders/:id/shiped' => 'orders#ship_order', as: :ship_order
    get 'orders/already/ship' => 'orders#index_orders_already_ship'
    get 'orders/:id/received' => 'orders#receive_order'
    get 'orders/already/receive' => 'orders#index_orders_already_receive'
    get 'orders/:id/oked' => 'orders#ok_order'
    get 'orders/already/ok' => 'orders#index_orders_already_ok'
    get 'orders/wait/back' => 'orders#index_orders_back'
    get 'orders/already/cancel' => 'orders#index_orders_canceled'

    resources :invoices
    resources :products
    resources :inventories
    resources :comments
    resources :tags

    get 'ueditor_uploader/index'
    match 'ueditor_uploader/index', to: 'ueditor_uploader#index', via: :post

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
