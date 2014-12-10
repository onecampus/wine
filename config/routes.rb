Rails.application.routes.draw do
  root 'site#index'
  
  # product cat
  get 'customer/cats' => 'site#index_cats'
  get 'customer/cats/:cid/products' => 'site#index_cat_products'

  # customer shipaddress
  get 'customer/shipaddresses/new' => 'site#new_ship_address'
  match 'customer/shipaddresses/create', to: 'site#create_ship_address', via: :post
  get 'customer/shipaddresses' => 'site#index_ship_address'

  # product
  get 'customer/products/:id/show' => 'site#show_product'
  
  # product comment
  get 'customer/products/:id/comments/new' => 'site#new_comment'
  match 'customer/products/:id/comments/create', to: 'site#create_comment', via: :post
  get 'customer/products/:id/comments' => 'site#index_comments'
  get 'customer/products/search' => 'site#index_search_result'

  get 'customer/commission' => 'site#commission'

  # user center
  get 'customer/cart' => 'site#index_shopping_cart'
  get 'customer/usercenter' => 'site#user_center'
  get 'customer/user/vipcard' => 'site#show_vip_card'

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  scope '/admin' do
    resources :products
    resources :inventories
    resources :comments
    resources :tags

    resources :shipaddresses

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
end
