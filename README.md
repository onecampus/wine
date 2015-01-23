# README #

众联酒业微信商城

### 开发介绍 ###

* rails version 4.1.9
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

# 如果需要重置数据库
rake db:reset
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
.paginate(page: params[:page], per_page: 10).order('id DESC')

authorize_resource
respond_to :html, :json
```
4. 修改ability
5. routes.rb
6. 修改前端页面和controller业务逻辑


### 金钱缩写

1. CNY(Chinese Yuan)人民币
2. FRF(French Franc)法国法郎
3. HKD(HongKong Dollar)港元
4. CHF(德文schweizer Franken)瑞士法郎
5. USD(United States Dollar)美元
6. CAD(Canadian Dollar)加拿大元
7. GBP(GreatBritain Pound)英镑
8. NLG(NetherLandish Guilder)荷兰盾
9. DEM(德文Deutsche Mark)德国马克
10. BEF(Belgischer Franc)比利时法郎
11. JPY(Japanese Yen)日元
12. AUD(Australian Dollar)澳大利亚元

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
rails g scaffold Vritualcard user_id:integer money:string
rails g scaffold Integral user_id:integer amount:string

rails g scaffold Invoice rise:string content:text
rails g scaffold Order invoice_id:integer user_id:integer order_number:string ship_address:string ship_method:string payment_method:string freight:string package_charge:string total_price:string buy_date:datetime order_status:integer pay_status:integer logistics_status:integer operator:integer cancel_reason:string weixin_open_id:string receive_name:string mobile:string tel:string supplier_id:integer order_type:string
rails g scaffold ProductOrder order_id:integer product_id:integer product_count:integer unit_price:string

rails g scaffold PrizeAct name:string desc:string prize_type:string start_time:datetime end_time:datetime is_open:integer join_num:integer person_limit:integer
rails g scaffold PrizeConfig prize_act_id:string prize_name:string min:string max:string prize_content:string prize_inventory:integer chance:integer
rails g scaffold PrizeUser user_id:integer prize_config_id:integer
rails g scaffold PrizeUserNumber user_id:integer number:integer prize_act_id:integer
rails g migration AddGetedToPrizeUsers geted:integer

rails g migration AddFrightToProducts fright:string


rails g migration AddPhoneToUsers phone:string
rails g migration AddVerificationMethodToUsers verification_method :string
rails g migration AddPhoneCodeToUsers phone_code:string
rails g migration AddPhoneCodeSentAtToUsers phone_code_sent_at:datetime

rails g scaffold Group product_id:integer start_time:datetime end_time:datetime limit_people_count:integer limit_product_count:integer description:text price saveup discount people:integer
rails g scaffold Seckill product_id:integer start_time:datetime end_time:datetime limit_people_count:integer limit_product_count:integer description:text price saveup discount people:integer

# rails g migration UserGroup user_id:integer group_id:integer count:integer
# rails g migration UserSeckill user_id:integer seckill_id:integer count:integer

rails g scaffold GroupOrder order_id:integer group_id:integer group_count:integer unit_price:string
rails g scaffold SeckillOrder order_id:integer seckill_id:integer seckill_count:integer unit_price:string

rails g scaffold SiteConfig key val img config_type
rails g uploader site_config_img

rails g migration AddInviteCodeToOrders invite_code:string
rails g migration AddShareLinkCodeToOrders share_link_code:string

rails g scaffold Withdraw user_id:integer bank_card alipay we_chat_payment draw_type

rails g migration AddDrawMoneyToWithdraws draw_money:string
rails g migration AddDrawStatusToWithdraws draw_status:integer

rails g scaffold Commission user_id:integer order_id:integer commission_money percent
rails g migration AddFromUserIdToWithdraws from_user_id:integer

rails g migration AddExpressNumberToOrders express_number:string
rails g migration AddExpressCompanyToOrders express_company:string
rails g migration AddExpressCompanyNumberToOrders express_company_number:string

rails g migration AddLimitPerPersonToGroups limit_per_person:integer
rails g migration AddRemainToGroups remain:integer

rails g migration AddLimitPerPersonToSeckills limit_per_person:integer
rails g migration AddRemainToSeckills remain:integer

rails g migration AddIsCommissionToProducts is_commission:integer
rails g migration AddIsCommissionToSeckills is_commission:integer
rails g migration AddIsCommissionToGroups is_commission:integer
rails g money_rails:initializer

rails g model WxMenu name msg_or_url:integer url title description:text img msg_type media_id button_type key parent_id:integer level:integer

# rails g migration change_price_type_in_products

rails g uploader weixin_uploader


rails g migration AddFromUserIdToCommissions from_user_id:integer
```

### 功能分析 ###

#### 一个厂家 ####

1. 登陆后台查看整个经销链
2. 商品分类（增/删/改/查）
3. 商品（增/删/改/查）
4. 订单查询与统计功能
5. 月/季度/年销售额报表统计
6. 销售利润
7. 微信基本功能管理（自定义菜单等）
8. 渠道商管理（增/删/改/查）
9. 客户管理
10. 商品上架下架
11. 团购管理

#### 区域经销商 ####

1. 登陆后台查看渠道商自己的经销链
2. 订单查询与统计功能
3. 月/季度/年销售额报表统计（延后）
4. 销售利润
5. 客户管理

#### 客户(若干分销商) ####

1. 用户注册，登陆，浏览商品，购物车
2. 下订单
3. 微信支付
4. 填写收货地址（一对多）
5. 查看物流状态，订单状态
6. 查看历史订单
7. 搜索商品
8. 登陆后台查看自己的BC
9. 自己的提成
10. LBS地理定位
11. 会员卡，积分，电子钱包
12. 首次进入商城购买时按照gps定位来确定该消费者属于哪个渠道商，假如该区域没有渠道商该会员直接归属厂家
13. 注册成会员后分享产品链接如产生购买消费，转发链接的会员即成为提成体系里面A级分销商，引用该分销商链接购买成功的消费者即成为提成体系里面A级分销商的下家-B级分销商，A可以在B购买成功的订单里面获得提成；B级分销商如果继续转发产品链接从而衍生购买，该购买者即成为A级分销商的下下家-C级分销商 A、B可以在C购买成功的订单获得提成；假如C继续转发衍生购买，A没有提成但B还有； 营收关系由A-B-C，只有三层；每一级都是A都有属于自己的BC  属于树型扩散结构（除了分享链接之外，令一个可以形成营收关系结构的是：任意消费者购买之后会得到邀请码，该邀请码按照树型结构扩散下去一样形成ABC分销商关系）

#### 其他问题 ####
1. 域名，服务器（linux）(甲方购买)
2. 微信服务号由甲方申请提供
3. 商品的上架与下架权限给--厂家
4. 客户A购买商品后，成为会员，他会有一张会员卡，虚拟的，可充值。上面有一个邀请码，可享受优惠
5. 整个商城的分销商链是固定的，不是针对单个商品，分销商链是树形结构的
6. ABCDEF，F购买了商品，那么只有DE能拿到提成
7. 邀请码和分享链接冲突，以邀请码为准
8. 客户的归属以第一次LBS为准
9. 邮件服务器用sendcloud（由甲方购买）
10. 邀请码是必须购买东西才能获取，而分享链接直接注册后就可以
11. 由甲方提供会员积分策略
12. 电子钱包相对来说是不安全的，出来问题乙方不负法律责任

### 问题 ###

* 域名(乙方购买)
* 服务器(ubuntu server 12.04/14.04，建议阿里云或者腾讯云)
* 微信服务号
* 工单号问题
* 发票问题
* 分销商能否登陆后台？(不能)
* 商品的上架与下架权限给谁？(厂家)
* 提成公式，也就是各级代理，或者成为分销商的提成怎么计算？
* 如何成为分销商？(普通注册会员即可)
* A购买商品后，成为会员，他会有一张会员卡，虚拟的，可充值。上面有一个邀请吗，可享受优惠。
* 没一件商品的分销商不同
* 虚拟会员卡充值要做，但是不负安全责任
* 目前就支持微信支付
* 厂家的微信基本管理
* 整个商城的ABC是固定的，不是针对单个商品
* 分销商链是全局的
* ABCDEF，F购买了商品，那么只有DE能拿到提成
* 邀请码和分享链接冲突，以邀请码为准
* 分销商链是树形结构的
* 通过邀请码进入的，算不算入分销链？？？（邀请码和分享链接都是构成分销链的关键，也就是算进去）
* 换句话说，整个商城的消费者都在这10条分销链里面，如果把厂家作为根节点，那么就只有一条分销链
* 渠道商是用来发货的，与ABC无关
* 第一波进来的发展成为A
* 地域以第一次LBS为准
* 邮件服务器用sendcloud
* 邀请码是必须购买东西才能获取，而分享链接直接注册后就可以
* 如果用户在微信中（Web微信除外）访问公众号的第三方网页，公众号开发者可以通过此接口获取当前用户基本信息（包括昵称、性别、城市、国家）。
* 收货地址共享(收货地址共享，是指可在微信中，调用微信的地址组件，此地址首次调用需用户授权，用户授权后，收货地址可在不同网页中共享使用，地址数据会传递到商户后台。)
* 接入维权系统--必须接入
* 积分策略问题（还未解决）

## 客户需求（众联酒业微信公众账号搭建+crm系统定制） ##

### 微信搭建： ###

1.产品商城（商城页面设计需要完全定制，商城具备lbs定位功能，有下单选择地域功能、有物流查询功能，其余商城必备的功能可以参考一些成熟电商app）
2.会员中心（具备可充值、积分、会员卡等级的会员卡；钱包功能：用来给会员查看自己的B、C级分销商数量以及实时产生的提成）
3.论坛功能（pass 掉）
4.微官网（pass 掉）
5.（暂定这些，其他的花俏功能后期再加------后期的功能后期说）

### crm： ###

#### 后台分两级： ####

* 首先是最顶级的厂家，这个等级的权限可以操作后台一切功能
* 其次是渠道商级别，前期暂时开启10-15个权限，到后期如果有新的渠道商，厂家可以自己增加渠道商后台账号，渠道商至具备看到属于自己的订单、属于自己的会员

#### 订单功能 ####

* 后台需要有清晰的订单功能：每一个订单对应的微信用户名、手机号、订单日期、订单金额、订单内容明细、物流情况、发货功能、订单所属渠道商等 需要一一对应列出

#### 微信管理功能： ####

* 在此板块中体现微信菜单设置（三宫十五格）、商城页面设置、商城广告位置设置等等

#### 产品管理 ####

* 商城产品上下架管理、库存管理、各渠道商产品库存情况、团购板块的产品管理

#### 会员管理 ####

* 总会员情况、各渠道商的会员情况、会员卡充值积分明细

#### 营销管理 ####

* 首次进入商城购买时按照gps定位来确定该消费者属于哪个渠道商，假如该区域没有渠道商该会员直接归属厂家
* 注册成会员后分享产品链接如产生购买消费，转发链接的会员即成为提成体系里面A级分销商，引用该分销商链接购买成功的消费者即成为提成体系里面A级分销商的下家-B级分销商，A可以在B购买成功的订单里面获得提成；B级分销商如果继续转发产品链接从而衍生购买，该购买者即成为A级分销商的下下家-C级分销商 A、B可以在C购买成功的订单获得提成；假如C继续转发衍生购买，A没有提成但B还有； 营收关系由A-B-C，只有三层；每一级都是A都有属于自己的BC  属于树型扩散结构
（除了分享链接之外，令一个可以形成营收关系结构的是：任意消费者购买之后会得到邀请码，该邀请码按照树型结构扩散下去一样形成ABC分销商关系）

#### 微信开发部分 ####

* access_token: https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wxa2bbd3b7a22039df&secret=724bbaea1bce4c09865c2c47acbf450d
* 商家不能主动向客户打钱！！！

#### 移动端框架 ####
* 点击事件框架quojs http://quojs.tapquo.com
* dom操作框架 jquery2

#### 2015-01-17

* 总仓可以看到其他供应商的库存
* /admin/profiles?action=index&role=customer&type=all 添加供应商归属
* 用户资料查看的时候显示基本资料(注册日期), 交易流水(订单记录), 转发次数(待定), 提成记录(提成总额), 导出excel
* 微信模板告知客户订单状态
* /admin/orders 添加订单状态, 供应商是否处理等
* 菜单那里加数字提醒
* 提成公式分整个商城(和单个商品的, 待定), 商品是否参加提成(按钮)(后台设置)
* 商品, 团购, 秒杀都参与提成
* 积分问题(待定)
* 邀请码用户自己复制输入, 邀请码打折设置, 统一折扣
* 微信菜单




### 测试 ###

* 无

### 联系我 ###

* yangkang@thecampus.cc
* sysuyangkang@gmail.com
