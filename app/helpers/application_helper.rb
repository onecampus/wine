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
        code: 'ems',
        company: 'ems快递'
      },
      {
        code: 'shunfeng',
        company: '顺丰'
      },
      {
        code: 'shentong',
        company: '申通'
      },
      {
        code: 'yuantong',
        company: '圆通速递'
      },
      {
        code: 'zhaijisong',
        company: '宅急送'
      },
      {
        code: 'yafengsudi',
        company: '亚风速递'
      },
      {
        code: 'quanyikuaidi',
        company: '全一快递'
      },
      {
        code: 'tiantian',
        company: '天天快递'
      },
      {
        code: 'zhongtiekuaiyun',
        company: '中铁快运'
      },
      {
        code: 'yunda',
        company: '韵达快运'
      },
      {
        code: 'sue',
        company: '速尔物流'
      },
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
        code: 'feikangda',
        company: '飞康达物流'
      },
      {
        code: 'fenghuangkuaidi',
        company: '凤凰快递'
      },
      {
        code: 'feikuaida',
        company: '飞快达'
      },
      {
        code: 'guotongkuaidi',
        company: '国通快递'
      },
      {
        code: 'ganzhongnengda',
        company: '港中能达物流'
      },
      {
        code: 'guangdongyouzhengwuliu',
        company: '广东邮政物流'
      },
      {
        code: 'gongsuda',
        company: '共速达'
      },
      {
        code: 'huitongkuaidi',
        company: '汇通快运'
      },
      {
        code: 'hengluwuliu',
        company: '恒路物流'
      },
      {
        code: 'huaxialongwuliu',
        company: '华夏龙物流'
      },
      {
        code: 'haihongwangsong',
        company: '海红'
      },
      {
        code: 'haiwaihuanqiu',
        company: '海外环球'
      },
      {
        code: 'jiayiwuliu',
        company: '佳怡物流'
      },
      {
        code: 'jinguangsudikuaijian',
        company: '京广速递'
      },
      {
        code: 'jixianda',
        company: '急先达'
      },
      {
        code: 'jjwl',
        company: '佳吉物流'
      },
      {
        code: 'jymwl',
        company: '加运美物流'
      },
      {
        code: 'jindawuliu',
        company: '金大物流'
      },
      {
        code: 'jialidatong',
        company: '嘉里大通'
      },
      {
        code: 'jykd',
        company: '晋越快递'
      },
      {
        code: 'kuaijiesudi',
        company: '快捷速递'
      },
      {
        code: 'lianb',
        company: '联邦快递（国内）'
      },
      {
        code: 'lianhaowuliu',
        company: '联昊通物流'
      },
      {
        code: 'longbanwuliu',
        company: '龙邦物流'
      },
      {
        code: 'lijisong',
        company: '立即送'
      },
      {
        code: 'lejiedi',
        company: '乐捷递'
      },
      {
        code: 'minghangkuaidi',
        company: '民航快递'
      },
      {
        code: 'meiguokuaidi',
        company: '美国快递'
      },
      {
        code: 'menduimen',
        company: '门对门'
      },
      {
        code: 'ocs',
        company: 'OCS'
      },
      {
        code: 'peisihuoyunkuaidi',
        company: '配思货运'
      },
      {
        code: 'quanchenkuaidi',
        company: '全晨快递'
      },
      {
        code: 'quanfengkuaidi',
        company: '全峰快递'
      },
      {
        code: 'quanjitong',
        company: '全际通物流'
      },
      {
        code: 'quanritongkuaidi',
        company: '全日通快递'
      },
      {
        code: 'rufengda',
        company: '如风达'
      },
      {
        code: 'santaisudi',
        company: '三态速递'
      },
      {
        code: 'shenghuiwuliu',
        company: '盛辉物流'
      },
      {
        code: 'shengfeng',
        company: '盛丰物流'
      },
      {
        code: 'saiaodi',
        company: '赛澳递'
      },
      {
        code: 'tiandihuayu',
        company: '天地华宇'
      },
      {
        code: 'tnt',
        company: 'tnt'
      },
      {
        code: 'ups',
        company: 'ups'
      },
      {
        code: 'wanjiawuliu',
        company: '万家物流'
      },
      {
        code: 'wenjiesudi',
        company: '文捷航空速递'
      },
      {
        code: 'wuyuan',
        company: '伍圆'
      },
      {
        code: 'wxwl',
        company: '万象物流'
      },
      {
        code: 'xinfengwuliu',
        company: '信丰物流'
      },
      {
        code: 'yibangwuliu',
        company: '一邦速递'
      },
      {
        code: 'youshuwuliu',
        company: '优速物流'
      },
      {
        code: 'youzhengguonei',
        company: '邮政包裹挂号信'
      },
      {
        code: 'youzhengguoji',
        company: '邮政国际包裹挂号信'
      },
      {
        code: 'yuanchengwuliu',
        company: '远成物流'
      },
      {
        code: 'yuanweifeng',
        company: '源伟丰快递'
      },
      {
        code: 'yuanzhijiecheng',
        company: '元智捷诚快递'
      },
      {
        code: 'yuntongkuaidi',
        company: '运通快递'
      },
      {
        code: 'yuefengwuliu',
        company: '越丰物流'
      },
      {
        code: 'yad',
        company: '源安达'
      },
      {
        code: 'yinjiesudi',
        company: '银捷速递'
      },
      {
        code: 'zhongtong',
        company: '中通速递'
      },
      {
        code: 'zhongyouwuliu',
        company: '中邮物流'
      },
      {
        code: 'zhongxinda',
        company: '忠信达'
      },
      {
        code: 'zhimakaimen',
        company: '芝麻开门'
      }
    ]
  end

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
