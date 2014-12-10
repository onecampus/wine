# README #

众联酒业微信商城

### 开发介绍 ###

* rails version 4.1.8
* ruby version 2.1.5
* apache + passenger
* mysql5

### 部署 ###

```ruby
git clone git@github.com:onecampus/wine.git
cd wine
cp ./config/database.yml.example ./config/database.yml
# 编辑 database.yml, 修改为你的 mysql 数据库密码, 其他最好别动
bundle install
rake db:create # 创建数据库
rake db:migrate # 导入数据库表
rake db:seed # 导入测试数据
rails s # 启动开发服务器
# 访问 http://127.0.0.1:3000/ 这是手机端, 可以缩小浏览器窗口查看
# 后台 http://127.0.0.1:3000/admin/products 需要登陆
# 用户名: admin@gmail.com
# 密码　: 12345678
```

### github workflow

```bash
git clone git@github.com:onecampus/wine.git
git branch -r
git checkout -b dev origin/dev # 检出 dev 分支, 并对应到本地的dev分支
git checkout -b your_name dev # 创建自己的私有分支, start_point 为dev
# 做修改, 提交, 注意不要推送到远程
git checkout dev # 切换到 dev 分支
git pull # 拉取远程更新
# 如果拉取遇到问题, 可能需要 git branch --set-upstream-to=origin/dev dev
git merge --no-ff your_name # 合并 your_name 到当前分支, 这里是 dev, 必须使用 --no-ff
git branch -d your_name # 删除 your_name 本地分支
git push origin dev # 推送 dev 分支到远程
```

### 注意

1. 在每次合并前, 都要先 `git pull` 来拉取远程更新, 然后再合并
2. 除了我外, 其他人不要操作 `master` 分支
3. 多用 `git status`, `git branch`, `git log`
4. 把不用的文件加入到 `.gitignore`, 例如 `.idea`
5. 不要直接在 `dev` 分支上开发, 按步骤来, 先建立自己的私有分支, 开发后再合并
6. 保证每一次提交都是必要的, 而不是为了保存代码就做一次提交
7. 当合并功能分支的时候，加上 `-no-ff` 选项强制进行一次全新的commit

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

### 测试 ###

* 无

### 联系我 ###

* yangkang@thecampus.cc
* sysuyangkang@gmail.com
