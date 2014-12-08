# README #

众联酒业微信商城

### 开发介绍 ###

* rails version 4.1.8
* ruby version 2.1.5
* apache + passenger
* mysql5

### 部署 ###

```ruby
bundle install
rake db:create
rake db:migrate
rake db:seed
rails s
```

### 脚手架一个model后的步骤

1. 添加字段翻译zh-CN.yml
2. 修改model对应关系
3. controller里面添加分页和
```ruby
.paginate(:page => params[:page], :per_page => 10).order('id DESC')

authorize_resource
respond_to :html, :json
```
4. 修改ability
5. routes.rb
6. 修改前端页面和controller业务逻辑

### TODOLIST ###

1. 总仓用户管理(管理区域分销商和客户) ok
2. 总仓分类管理(限制为一级分类) ok
3. 总仓商品管理(增删改查/商品上架下架)
4. 总仓订单管理(针对自己的客户)

1. 区域经销商用户管理(客户)
2. 区域经销商订单管理(针对自己的客户)

1. 客户注册/邮件确认/登陆/重置密码/修改基本资料
2. 浏览商品/购物车/填写收货地址/下订单/微信支付/查看物流状态，订单状态/查看历史订单
3. 搜索商品
4. 登陆后台查看自己的BC和提成
5. 邀请码(邀请码是必须购买东西才能获取，而分享链接直接注册后就可以)
6. 分享链接(邀请码和分享链接冲突，以邀请码为准)

1. 总仓团购管理(团购基于商品)
2. 客户会员卡，积分，电子钱包
3. 会员积分策略
4. 总仓会员管理/各渠道商的会员情况/会员卡充值积分明细

1. 工单号问题
2. 发票问题
3. 提成公式
4. 库存管理、各渠道商产品库存情况

```ruby

```

### CMD ###

```ruby
rails new base -d mysql --skip-bundle

rails g controller Site index show_post index_cats index_cat_posts

# config the layout

# add gem 'devise'
rails generate devise:install
# config root and development.rb
rails generate devise User
# add before_action :authenticate_user!

# add cancancan rolify gem
rails g cancan:ability
rails generate rolify Role User


# role controller and view in admin
rails g scaffold Role name:string resource_id:integer resource_type:string

# user controller and view in admin
rails g scaffold User name:string email:string encrypted_password:string reset_password_token:string reset_password_sent_at:datetime remember_created_at:datetime sign_in_count:integer current_sign_in_at:datetime last_sign_in_at:datetime current_sign_in_ip:string last_sign_in_ip:string confirmation_token:string confirmed_at:datetime confirmation_sent_at:datetime unconfirmed_email:string

# cat
rails g scaffold Cat title:string content:text secret_field:text name:string parent_id:integer lft:integer rgt:integer depth:integer

rails generate migration add_username_to_users username:string:uniq

rails generate devise:views

rails generate devise:controllers users

# gem ckeditor
rails generate ckeditor:install --orm=active_record --backend=carrierwave

# gem 'acts-as-taggable-on', '~> 3.4'
rake acts_as_taggable_on_engine:install:migrations

# article
rails g scaffold Article title:string summary:text content:text markdown_content:text user_id:integer author:string img:string publish_time:datetime cat_id:integer is_hot:integer is_published:integer is_recommend:integer can_comment:integer start_time:datetime end_time:datetime address:text speaker:string emcee:string organizer:string sponsor:string source:string

# article img
rails g uploader article_img

# gem acts_as_commentable_with_threading
rails generate acts_as_commentable_with_threading_migration

# comment controller and view in admin
rails g scaffold Comment commentable_id:integer commentable_type:string title:string body:text subject:string user_id:integer parent_id:integer lft:integer rgt:integer

# tag controller and view in admin
rails g scaffold Tag name:string taggings_count:integer


# 用户其他资料数据表
rails g scaffold Profile supplier_id:integer is_locked:integer user_id:integer parent_id:integer lft:integer rgt:integer depth:integer mobile:string tel:string province:string city:string region:string address:string fax:string invite_code:string share_link_code:string default_address_id:integer weixin_open_id:string
rails g scaffold Product name:string price:string img:string cat_id:integer description:text brand:string expiration_date:datetime country:string package_type:string product_model:string status:integer profit:string vip_price:string is_new:integer is_boutique:integer unit:string
rails g uploader ProductImg
rails g scaffold Inventory user_id:integer product_id:integer amount:integer
rails g scaffold Shipaddress user_id:integer receive_name:string province:string city:string region:string address:string postcode:string tel:string mobile:string
rails g migration add_img_to_cats img:string
rails g uploader CatImg
rails g scaffold Invoice rise:string content:text
rails g scaffold Order invoice_id:integer user_id:integer order_number:string ship_address:string ship_method:string payment_method:string freight:string package_charge:string total_price:string buy_date:datetime order_status:integer pay_status:integer logistics_status:integer operator:integer cancel_reason:string weixin_open_id:string receive_name:string mobile:string tel:string supplier_id:integer order_type:string
rails g scaffold ProductOrder order_id:integer product_id:integer product_count:integer unit_price:string



rails g scaffold Vritualcard user_id:integer money:string

rails g scaffold Integral user_id:integer amount:string

rails g scaffold Group start_time:datetime end_time:datetime limit_count:integer description:text price:string

rails g scaffold ProductGroup group_id:integer product_id:integer
```


#### cancancan with custom action

```ruby

```

```ruby
# note
```

### 测试 ###

* 要求必须写测试

### 联系我 ###

### xxx ###

* yangkang@thecampus.cc
