module ApplicationHelper
  # order_status: {1: 未处理, 2: 已确定, 3: 已取消}
  # pay_status: {1: 未付款, 2: 已付款}
  # logistics_status: {1: 备货中, 2: 已发货, 3: 已收货, 4: 已退货}
  def order_status(status)
    case status
      when 1
        '未处理'
      when 2
        '已确定'
      when 3
        '已取消'
      else
        '未知错误'
    end
  end

  def pay_status(status)
    case status
      when 1
        '未付款'
      when 2
        '已付款'
      else
        '未知错误'
    end
  end

  def logistics_status(status)
    case status
      when 0
        '订单还未处理'
      when 1
        '备货中'
      when 2
        '已发货'
      when 3
        '已收货'
      when 4
        '已退货'
      else
        '未知错误'
    end
  end

  def express_companies
    [
      {
        code: 'aae',
        company: 'aae全球专递'
      },
      {
        code: 'anjie',
        company: '安捷快递'
      },
      {
        code: 'anxindakuaixi',
        company: '安信达快递'
      },
      {
        code: 'biaojikuaidi',
        company: '彪记快递'
      },
      {
        code: 'bht',
        company: 'bht'
      },
      {
        code: 'baifudongfang',
        company: '百福东方国际物流'
      },
      {
        code: 'coe',
        company: '中国东方（COE）'
      },
      {
        code: 'changyuwuliu',
        company: '长宇物流'
      },
      {
        code: 'datianwuliu',
        company: '大田物流'
      },
      {
        code: 'baifudongfang',
        company: '百福东方国际物流'
      },
      {
        code: 'debangwuliu',
        company: '德邦物流'
      },
      {
        code: 'dhl',
        company: 'dhl'
      },
      {
        code: 'dpex',
        company: 'dpex'
      },
      {
        code: 'dsukuaidi',
        company: 'd速快递'
      },
      {
        code: 'disifang',
        company: '递四方'
      },
      {
        code: 'fedex',
        company: 'fedex（国外）'
      },
      {
        code: 'ems',
        company: 'ems快递'
      },
      {
        code: 'feikangda',
        company: '飞康达物流'
      },
    ]
  end


  feikangda
  飞康达物流
  fenghuangkuaidi
  凤凰快递
  feikuaida
  飞快达
  guotongkuaidi
  国通快递
  ganzhongnengda
  港中能达物流
  guangdongyouzhengwuliu
  广东邮政物流
  gongsuda
  共速达
  huitongkuaidi
  汇通快运
  hengluwuliu
  恒路物流
  huaxialongwuliu
  华夏龙物流
  haihongwangsong
  海红
  haiwaihuanqiu
  海外环球
  jiayiwuliu
  佳怡物流
  jinguangsudikuaijian
  京广速递
  jixianda
  急先达
  jjwl
  佳吉物流
  jymwl
  加运美物流
  jindawuliu
  金大物流
  jialidatong
  嘉里大通
  jykd
  晋越快递
  kuaijiesudi
  快捷速递
  lianb
  联邦快递（国内）
  lianhaowuliu
  联昊通物流
  longbanwuliu
  龙邦物流
  lijisong
  立即送
  lejiedi
  乐捷递
  minghangkuaidi
  民航快递
  meiguokuaidi
  美国快递
  menduimen
  门对门
  ocs
  OCS
  peisihuoyunkuaidi
  配思货运
  quanchenkuaidi
  全晨快递
  quanfengkuaidi
  全峰快递
  quanjitong
  全际通物流
  quanritongkuaidi
  全日通快递
  quanyikuaidi
  全一快递
  rufengda
  如风达
  santaisudi
  三态速递
  shenghuiwuliu
  盛辉物流
  shentong
  申通
  shunfeng
  顺丰
  sue
  速尔物流
  shengfeng
  盛丰物流
  saiaodi
  赛澳递
  tiandihuayu
  天地华宇
  tiantian
  天天快递
  tnt
  tnt
  ups
  ups
  wanjiawuliu
  万家物流
  wenjiesudi
  文捷航空速递
  wuyuan
  伍圆
  wxwl
  万象物流
  xinbangwuliu
  新邦物流
  xinfengwuliu
  信丰物流
  yafengsudi
  亚风速递
  yibangwuliu
  一邦速递
  youshuwuliu
  优速物流
  youzhengguonei
  邮政包裹挂号信
  youzhengguoji
  邮政国际包裹挂号信
  yuanchengwuliu
  远成物流
  yuantong
  圆通速递
  yuanweifeng
  源伟丰快递
  yuanzhijiecheng
  元智捷诚快递
  yunda
  韵达快运
  yuntongkuaidi
  运通快递
  yuefengwuliu
  越丰物流
  yad
  源安达
  yinjiesudi
  银捷速递
  zhaijisong
  宅急送
  zhongtiekuaiyun
  中铁快运
  zhongtong
  中通速递
  zhongyouwuliu
  中邮物流
  zhongxinda
  忠信达
  zhimakaimen
  芝麻开门


  def country_to_select
    [
      "中国",
      "中国澳门",
      "中国台湾",
      "中国香港",
      "阿尔及利亚",
      "阿富汗",
      "阿根廷",
      "阿联酋",
      "阿曼",
      "阿塞拜疆",
      "埃及",
      "埃塞俄比亚",
      "爱尔兰",
      "安哥拉",
      "奥地利",
      "澳大利亚",
      "巴布亚新几内亚",
      "巴基斯坦",
      "巴林",
      "巴西",
      "白俄罗斯",
      "保加利亚",
      "贝宁",
      "比利时",
      "冰岛",
      "波黑",
      "波兰",
      "博茨瓦纳",
      "朝鲜",
      "赤道几内亚",
      "大溪地",
      "丹麦",
      "德国",
      "多哥",
      "俄罗斯",
      "厄瓜多尔",
      "厄立特里亚",
      "法国",
      "菲律宾",
      "斐济",
      "芬兰",
      "佛得角",
      "刚果(布)",
      "刚果(金)",
      "高棉",
      "古巴",
      "圭亚那",
      "哈萨克斯坦",
      "韩国",
      "荷兰",
      "吉尔吉斯斯坦",
      "几内亚",
      "加拿大",
      "加纳",
      "柬埔寨",
      "捷克",
      "津巴布韦",
      "喀麦隆",
      "卡塔尔",
      "科威特",
      "肯尼亚",
      "老挝",
      "黎巴嫩",
      "立陶宛",
      "利比亚",
      "罗马尼亚",
      "马达加斯加",
      "马来西亚",
      "马里",
      "马其顿",
      "毛里求斯",
      "毛里塔尼亚",
      "美国",
      "蒙古",
      "孟加拉国",
      "秘鲁",
      "缅甸",
      "摩洛哥",
      "摩洛哥公国",
      "莫桑比克",
      "墨西哥",
      "纳米比亚",
      "南非",
      "尼泊尔",
      "尼日利亚",
      "葡萄牙",
      "日本",
      "瑞典",
      "瑞士",
      "沙特阿拉伯",
      "斯里兰卡",
      "斯洛伐克",
      "苏丹",
      "塔吉克斯坦",
      "泰国",
      "坦桑尼亚",
      "突尼斯",
      "土耳其",
      "土库曼斯坦",
      "委内瑞拉",
      "文莱",
      "乌干达",
      "乌克兰",
      "乌拉圭",
      "乌兹别克斯坦",
      "西班牙",
      "希腊",
      "新加坡",
      "新西兰",
      "匈牙利",
      "叙利亚",
      "牙买加",
      "亚美尼亚",
      "也门",
      "伊拉克",
      "伊朗",
      "以色列",
      "意大利",
      "印度",
      "印尼",
      "英国",
      "约旦",
      "越南",
      "赞比亚"
    ]
  end
end
