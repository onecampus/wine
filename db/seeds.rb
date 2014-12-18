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

prize_act = PrizeAct.new(
  name: '送iphone7',
  desc: '送iphone7，大转盘活动',
  prize_type: 'bigwheel',
  start_time: Time.now,
  end_time: Time.now + 3600 * 24,
  is_open: 1,
  join_num: 0,
  person_limit: 30
)
prize_act.save!

prize_config1 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '一等奖',
  min: '1',
  max: '29',
  prize_content: 'iphone 6',
  prize_inventory: 8,
  chance: 1
)
prize_config1.save!

prize_config2 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '二等奖',
  min: '302',
  max: '328',
  prize_content: 'iphone 5',
  prize_inventory: 8,
  chance: 2
)
prize_config2.save!

prize_config3 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '三等奖',
  min: '242',
  max: '268',
  prize_content: '现金500',
  prize_inventory: 8,
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
  prize_inventory: 8,
  chance: 10
)
prize_config5.save!

prize_config6 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '六等奖',
  min: '62',
  max: '88',
  prize_content: '现金100',
  prize_inventory: 8,
  chance: 25
)
prize_config6.save!

prize_config7 = PrizeConfig.new(
  prize_act_id: prize_act.id,
  prize_name: '七等奖',
  min: '32,92,152,212,272,332',
  max: '58,118,178,238,298,358',
  prize_content: '小熊宝宝一个',
  prize_inventory: 8,
  chance: 50
)
prize_config7.save!

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


time_end = Time.now
time = time_end - time_start
puts time.to_s
puts 'end seeds'
puts '==' * 20
