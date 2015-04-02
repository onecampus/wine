puts '==' * 20
puts 'start seeds'

time_start = Time.now


cats = [
  {name: '白酒', title: '白酒', content: '白酒', secret_field: 'secret_field'},
  {name: '红酒', title: '红酒', content: '红酒', secret_field: 'secret_field'},
  {name: '葡萄酒', title: '葡萄酒', content: '葡萄酒', secret_field: 'secret_field'},
  {name: '其他', title: '其他', content: '其他', secret_field: 'secret_field'}
]

cats.each do |c|
  Cat.create! c
end


u = User.new(
  username: 'admin',
  email: 'admin@gmail.com',
  password: '12345678',
  password_confirmation: '12345678'
)
u.skip_confirmation!
u.save!
u.add_role :admin
Profile.create(
  user_id: u.id,
  mobile: "135604744#{u.id}",
  tel: "5555#{u.id}",
  province: '广东省',
  city: '广州市',
  region: '番禺区',
  address: '小谷围',
  fax: '55555'
)
Integral.create(user_id: u.id, amount: 0)
Vritualcard.create(user_id: u.id, money: '0.00')


provider = User.new(
  username: 'provider',
  email: 'provider@gmail.com',
  password: '12345678',
  password_confirmation: '12345678'
)
provider.skip_confirmation!
provider.save!
provider.add_role :provider
Profile.create(
  user_id: provider.id,
  mobile: "135604744#{provider.id}",
  tel: "5555#{provider.id}",
  province: '广东省',
  city: '广州市',
  region: '番禺区',
  address: '小谷围',
  fax: '55555'
)
Integral.create(user_id: provider.id, amount: 0)
Vritualcard.create(user_id: provider.id, money: '0.00')


customer1 = User.new(
  username: 'customer1',
  email: 'customer1@gmail.com',
  password: '12345678',
  password_confirmation: '12345678'
)
customer1.skip_confirmation!
customer1.save!
customer1.add_role :customer
Profile.create(
  user_id: customer1.id,
  mobile: "135604744#{customer1.id}",
  tel: "5555#{customer1.id}",
  share_link_code: User.generate_share_link_code,
  invite_code: User.generate_invite_code,
  province: '广东省',
  city: '广州市',
  region: '番禺区',
  address: '小谷围',
  fax: '55555',
  supplier_id: provider.id
)
Integral.create(user_id: customer1.id, amount: 0)
Vritualcard.create(user_id: customer1.id, money: '0.00')
Score.create(user_id: customer1.id, mark: 0, remain_mark: 0)


customer2 = User.new(
  username: 'customer2',
  email: 'customer2@gmail.com',
  password: '12345678',
  password_confirmation: '12345678'
)
customer2.skip_confirmation!
customer2.save!
customer2.add_role :customer
Profile.create(
  user_id: customer2.id,
  mobile: "135604744#{customer2.id}",
  tel: "5555#{customer2.id}",
  share_link_code: User.generate_share_link_code,
  province: '广东省',
  city: '广州市',
  region: '番禺区',
  address: '小谷围',
  fax: '55555',
  supplier_id: provider.id
)
customer2.profile.move_to_child_of(customer1.profile)
customer1.profile.reload
Integral.create(user_id: customer2.id, amount: 0)
Vritualcard.create(user_id: customer2.id, money: '0.00')
Score.create(user_id: customer2.id, mark: 0, remain_mark: 0)

customer3 = User.new(
  username: 'customer3',
  email: 'customer3@gmail.com',
  password: '12345678',
  password_confirmation: '12345678'
)
customer3.skip_confirmation!
customer3.save!
customer3.add_role :customer
Profile.create(
  user_id: customer3.id,
  mobile: "135604744#{customer3.id}",
  tel: "5555#{customer3.id}",
  share_link_code: User.generate_share_link_code,
  province: '广东省',
  city: '广州市',
  region: '番禺区',
  address: '小谷围',
  fax: '55555',
  supplier_id: provider.id
)
customer3.profile.move_to_child_of(customer2.profile)
customer2.profile.reload
Integral.create(user_id: customer3.id, amount: 0)
Vritualcard.create(user_id: customer3.id, money: '0.00')
Score.create(user_id: customer3.id, mark: 0, remain_mark: 0)

=begin
1.upto(50).each do |i|
  if i == 1
    u = User.new(
      username: 'admin',
      email: 'admin@gmail.com',
      password: '12345678',
      password_confirmation: '12345678'
    )
    u.save
    u.confirm!
    u.add_role :admin
    Profile.create(
      user_id: u.id,
      mobile: "135604744#{u.id}",
      tel: "5555#{u.id}",
      province: '广东省',
      city: '广州市',
      region: '番禺区',
      address: '小谷围',
      fax: '55555'
    )
    Integral.create(user_id: u.id, amount: 0)
    Vritualcard.create(user_id: u.id, money: '0.00')
  elsif Array(2..10).include?(i)
    u = User.new(
      username: "provider#{i}",
      email: "provider#{i}@gmail.com",
      password: '12345678',
      password_confirmation: '12345678'
    )
    u.save
    u.confirm!
    u.add_role :provider
    Profile.create(
      user_id: u.id,
      mobile: "135604744#{u.id}",
      tel: "5555#{u.id}",
      province: '广东省',
      city: '广州市',
      region: '番禺区',
      address: '小谷围',
      fax: '55555'
    )
    Integral.create(user_id: u.id, amount: 0)
    Vritualcard.create(user_id: u.id, money: '0.00')
  else
    u = User.new(
      username: "customer#{i}",
      email: "customer#{i}@gmail.com",
      password: '12345678',
      password_confirmation: '12345678'
    )
    u.save
    u.confirm!
    u.add_role :customer

    Profile.create(
      supplier_id: rand(10),
      user_id: u.id,
      mobile: "135604744#{u.id}",
      tel: "5555#{u.id}",
      province: '广东省',
      city: '广州市',
      region: '番禺区',
      address: '小谷围',
      fax: '55555'
    )
    Integral.create(user_id: u.id, amount: 0)
    Vritualcard.create(user_id: u.id, money: '0.00')
  end
end
=end

prize_act = PrizeAct.new(
  name: '送iphone7',
  desc: '送iphone7，大转盘活动',
  prize_type: 'bigwheel',
  start_time: Time.now,
  end_time: Time.now + 3600 * 24,
  is_open: 1,
  join_num: 0,
  person_limit: 3
)
prize_act.save!

prize_config1 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '一等奖',
  min: '1',
  max: '29',
  prize_content: 'iphone 6',
  prize_inventory: 1,
  chance: 1
)
prize_config1.save!

prize_config2 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '二等奖',
  min: '302',
  max: '328',
  prize_content: 'iphone 5',
  prize_inventory: 2,
  chance: 2
)
prize_config2.save!

prize_config3 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '三等奖',
  min: '242',
  max: '268',
  prize_content: '现金500',
  prize_inventory: 3,
  chance: 5
)
prize_config3.save!

prize_config4 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '四等奖',
  min: '182',
  max: '208',
  prize_content: '现金300',
  prize_inventory: 8,
  chance: 7
)
prize_config4.save!

prize_config5 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '五等奖',
  min: '122',
  max: '148',
  prize_content: '现金200',
  prize_inventory: 20,
  chance: 10
)
prize_config5.save!

prize_config6 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '六等奖',
  min: '62',
  max: '88',
  prize_content: '现金100',
  prize_inventory: 50,
  chance: 25
)
prize_config6.save!

prize_config7 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '七等奖',
  min: '32,92,152,212,272,332',
  max: '58,118,178,238,298,358',
  prize_content: '谢谢惠顾',
  prize_inventory: 10_000_000,
  chance: 9950
)
prize_config7.save!

=begin
wm1 = WxMenu.new(
  name: '我的微网',
  msg: '',
  url: 'http://203.195.172.200/',
  msg_or_url: 1,
  button_type: 'view',
  key: '',
  parent_id: 0,
  level: 1
)
wm1.save!

names1 = [
  '会员中心',
  '我也加盟',
  '天天有喜',
  '官网首页'
]
names1.each do |sn|
  wm_tmp = WxMenu.new(
    name: sn,
    msg: '',
    url: 'http://203.195.172.200/',
    msg_or_url: 1,
    button_type: 'view',
    key: '',
    parent_id: wm1.id,
    level: 2
  )
  wm_tmp.save!
end

wm2 = WxMenu.new(
  name: '优生活',
  msg: '',
  url: 'http://203.195.172.200/',
  msg_or_url: 1,
  button_type: 'view',
  key: '',
  parent_id: 0,
  level: 1
)
wm2.save!

names2 = [
  '优社区',
  '生活高手',
  '一起嗨皮'
]
names2.each do |sn|
  wm_tmp = WxMenu.new(
    name: sn,
    msg: '',
    url: 'http://203.195.172.200/',
    msg_or_url: 1,
    button_type: 'view',
    key: '',
    parent_id: wm2.id,
    level: 2
  )
  wm_tmp.save!
end

wm3 = WxMenu.new(
  name: '我的微网',
  msg: '',
  url: 'http://203.195.172.200/',
  msg_or_url: 1,
  button_type: 'view',
  key: '',
  parent_id: 0,
  level: 1
)
wm3.save!

names3 = [
  '进口酒类',
  '舌尖上的特产',
  '最强推荐',
  '订单查询'
]
names3.each do |sn|
  wm_tmp = WxMenu.new(
    name: sn,
    msg: '',
    url: 'http://203.195.172.200/',
    msg_or_url: 1,
    button_type: 'view',
    key: '',
    parent_id: wm3.id,
    level: 2
  )
  wm_tmp.save!
end

wm1 = WxMenu.new(
  name: '购物专区',
  msg: '',
  url: 'http://203.195.172.200/',
  msg_or_url: 1,
  button_type: 'view',
  key: '',
  parent_id: 0,
  level: 1
)
wm1.save!

names1 = [
  '商城主页'
]
names1.each do |sn|
  wm_tmp = WxMenu.new(
    name: sn,
    msg: '',
    url: 'http://203.195.172.200/',
    msg_or_url: 1,
    button_type: 'view',
    key: '',
    parent_id: wm1.id,
    level: 2
  )
  wm_tmp.save!
end

wm2 = WxMenu.new(
  name: '礼品专区',
  msg: '',
  url: 'http://203.195.172.200/',
  msg_or_url: 1,
  button_type: 'view',
  key: '',
  parent_id: 0,
  level: 1
)
wm2.save!

names2 = [
  '有奖转盘'
]
names2.each do |sn|
  wm_tmp = WxMenu.new(
    name: sn,
    msg: '',
    url: 'http://203.195.172.200/customer/big/wheel',
    msg_or_url: 1,
    button_type: 'view',
    key: '',
    parent_id: wm2.id,
    level: 2
  )
  wm_tmp.save!
end

wm3 = WxMenu.new(
  name: '会员专区',
  msg: '',
  url: 'http://203.195.172.200/',
  msg_or_url: 1,
  button_type: 'view',
  key: '',
  parent_id: 0,
  level: 1
)
wm3.save!

names3 = [
  '最新动态',
  '倾情推荐',
  '未来预告'
]
names3.each do |sn|
  wm_tmp = WxMenu.new(
    name: sn,
    msg: '',
    url: 'http://203.195.172.200/',
    msg_or_url: 1,
    button_type: 'view',
    key: '',
    parent_id: wm3.id,
    level: 2
  )
  wm_tmp.save!
end
=end

# 用户首页图片设置
1.upto(3).each do |i|
  SiteConfig.create(
    key: "CustomerIndexImgConfigKey#{i}",
    val: "http://203.195.172.200",
    img: "CustomerIndexImgConfigImg#{i}",
    config_type: 'CustomerIndexImgConfig'
  )
end

# 第一级提成者百分比
SiteConfig.create!(
  key: 'current_order_commission_a',
  val: '0.1',
  img: 'current_order_commission_a',
  config_type: 'commission_config'
)
# 第二级提成者百分比
SiteConfig.create!(
  key: 'current_order_commission_b',
  val: '0.05',
  img: 'current_order_commission_b',
  config_type: 'commission_config'
)
# 第仨级提成者百分比
SiteConfig.create!(
  key: 'current_order_commission_c',
  val: '0.01',
  img: 'current_order_commission_c',
  config_type: 'commission_config'
)

# 用户提成分数计算，销售额x0.8=分数
SiteConfig.create!(
  key: 'product_score_percent',
  val: '0.8',
  img: 'product_score_percent',
  config_type: 'commission_config'
)

# 用户积分计算，任何人购买任意产品提成分数满100分可获得10积分
SiteConfig.create!(
  key: 'integral_score_percent',
  val: '10',
  img: 'integral_score_percent',
  config_type: 'integral_config'
)

# 用户积分和金钱对换计算，任何人的积分满100分可兑换10元钱用于支付
SiteConfig.create!(
  key: 'integral_to_money_percent',
  val: '10',
  img: 'integral_to_money_percent',
  config_type: 'integral_config'
)


time_end = Time.now
time = time_end - time_start
puts time.to_s
puts 'end seeds'
puts '==' * 20
