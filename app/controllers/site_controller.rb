# encoding: UTF-8
require 'json'
require 'rest_client'
require 'digest/sha1'

##
# This class is a controller for customer from weixin brower.
class SiteController < CustomerController
  layout 'customer'

  layout 'prize', only: [:scratch_off, :big_wheel]

  skip_before_filter :authenticate_user!, only: [:index,
                                                 :index_cats,
                                                 :show_product,
                                                 :index_comments,
                                                 :index_search_result,
                                                 :index_cat_products,
                                                 :index_wait_ship,
                                                 :index_wait_pay,
                                                 :index_wait_receive,
                                                 :index_order_history,
                                                 :create_order,
                                                 :scratch_off,
                                                 :big_wheel,
                                                 :index_groups_seckills,
                                                 :show_group,
                                                 :show_seckill]
  skip_before_filter :verify_authenticity_token, only: [:create_order,
                                                        :big_wheel_ajax,
                                                        :scratch_off_ajax,
                                                        :create_ship_address_via_ajax,
                                                        :create_invoice_via_ajax,
                                                        :create_withdraw]

  # 首页
  def index
    @site_config1 = SiteConfig.where(key: 'CustomerIndexImgConfigKey1', config_type: 'CustomerIndexImgConfig').first
    @site_config2 = SiteConfig.where(key: 'CustomerIndexImgConfigKey2', config_type: 'CustomerIndexImgConfig').first
    @site_config3 = SiteConfig.where(key: 'CustomerIndexImgConfigKey3', config_type: 'CustomerIndexImgConfig').first
    @last_3_products = Product.last 3
    @last_2_cats = Cat.last 2
  end

  # 提现
  def new_withdraw
    @vip_card = current_user.vritualcard
    @withdraw = Withdraw.new
  end

  # 提现记录列表
  def index_withdraws
    @withdraws = current_user.withdraws
  end

  # 创建提现
  def create_withdraw
    withdraw_params = {
      user_id: current_user.id,
      bank_card: params[:bank_card],
      alipay: params[:alipay],
      we_chat_payment: params[:we_chat_payment],
      draw_type: params[:draw_type],
      draw_money: params[:draw_money],
      draw_status: 0
    }
    @withdraw = Withdraw.new(withdraw_params)
    if @withdraw.save
      render json: { status: 'success', msg: 'action draw success' }
    else
      render json: { status: 'failed', msg: 'action draw failed' }
    end
  end

  # 分类列表
  def index_cats
    @cats = Cat.all
  end

  # 单个分类下的商品列表
  def index_cat_products
    @cat = Cat.find params[:cid]
    @cat_products = nil
    unless params[:sort].blank?
      case params[:sort]
      when 'sales'
        @cat_products = @cat.products.sort { |x, y| y.orders.count <=> x.orders.count }
      when 'popularity'
        @cat_products = @cat.products.sort { |x, y| y.comment_threads.count <=> x.comment_threads.count }
      when 'time'
        @cat_products = @cat.products.order('created_at DESC')
      else
        @cat_products = @cat.products.sort { |x, y| y.price.to_f <=> x.price.to_f }
      end
    else
      @cat_products = @cat.products.sort { |x, y| y.price.to_f <=> x.price.to_f }
    end
  end

  # 商品展示
  def show_product
    @product = Product.find params[:id]
    @share_hash = init_share_hash("/customer/products/#{params[:id]}/show")
  end

  # 团购秒杀列表
  def index_groups_seckills
    @groups = Group.all
    @seckills = Seckill.all
  end

  # 团购展示
  def show_group
    @group = Group.find params[:id]
    @share_hash = init_share_hash("/customer/groups/#{params[:id]}/show")
    @already_sell = 0
    @group.group_orders.each do |go|
      @already_sell += go.group_count
    end
  end

  # 秒杀展示
  def show_seckill
    @seckill = Seckill.find params[:id]
    @share_hash = init_share_hash("/customer/seckills/#{params[:id]}/show")
    @already_sell = 0
    @seckill.seckill_orders.each do |go|
      @already_sell += go.seckill_count
    end
  end

  # 添加评论
  def new_comment
    @product = Product.find params[:id]
  end

  # 创建评论
  def create_comment
    @product = Product.find params[:id]
    @user_who_commented = current_user
    @comment = Comment.build_from(@product, @user_who_commented.id, params[:content])
    if @comment.save
      flash.now[:alert] = '创建成功'
      redirect_to action: :index_comments
    else
      flash.now[:alert] = '创建失败'
      render action: :new_comment
    end
  end

  # 评论列表
  def index_comments
    @product = Product.find params[:id]
    @comments = @product.comment_threads.order('id DESC')
  end

  # 天加收货地址
  def new_ship_address
    @shipaddress = Shipaddress.new(params[:shipaddress])
  end

  # 创建收货地址
  def create_ship_address
    shipaddress_params = {
      user_id: current_user.id,
      receive_name: params[:receive_name],
      province: params[:province],
      city: params[:city],
      region: params[:region],
      address: params[:address],
      postcode: params[:postcode],
      tel: params[:tel],
      mobile: params[:mobile]
    }
    @shipaddress = Shipaddress.new(shipaddress_params)
    if @shipaddress.save
      flash.now[:alert] = '收货地址创建成功'
      redirect_to action: :index_ship_address
    else
      flash.now[:alert] = '收货地址创建失败'
      render action: :new_ship_address
    end
  end

  # ajax 创建收货地址接口
  def create_ship_address_via_ajax
    shipaddress_params = {
      user_id: current_user.id,
      receive_name: params[:receive_name],
      province: params[:province],
      city: params[:city],
      region: params[:region],
      address: params[:address],
      postcode: params[:postcode],
      tel: params[:tel],
      mobile: params[:mobile]
    }
    @shipaddress = Shipaddress.new(shipaddress_params)
    if @shipaddress.save
      render json: { status: 'success', msg: 'create ship address success.', data: @shipaddress.id }
    else
      render json: { status: 'failed', msg: 'create ship address failed.' }
    end
  end

  # 收货地址列表
  def index_ship_address
    @shipaddresses = current_user.shipaddresses
  end

  # 购物车
  def index_shopping_cart
  end

  # 用户中心
  def user_center
    @user = current_user
  end

  # 搜索结果列表
  def index_search_result
    q = params[:q]
    if q && q != ''
      @products = Product.where('name LIKE ?', "%#{q}%")
    else
      @products = []
    end
  end

  # 会员卡
  def show_vip_card
    @user = current_user
  end

  # 订单处理页面
  def order_settlement
    @shipaddresses = current_user.shipaddresses
    @invoices = current_user.invoices
    @current_integral = current_user.integral
  end

  # ajax添加发票
  def create_invoice_via_ajax
    @invoice = Invoice.new(
      rise: params[:rise],
      content: params[:content],
      user_id: current_user.id
    )
    if @invoice.save
      render json: { status: 'success', msg: 'create invoice success.',
                     data: @invoice.id }
    else
      render json: { status: 'failed', msg: 'create invoice failed.' }
    end
  end

  def create_order
    share_link_code = params[:share_link_code]  # 分享链接
    invite_code = params[:invite_code]  # 邀请码
    current_user_profile = current_user.profile  # 当前用户的额外信息

    # 收货地址
    shipaddress = Shipaddress.find params[:ship_address_id]
    # 发票
    invoice = nil
    invoice = Invoice.find(params[:invoice_id]) unless params[:invoice_id].blank?

    # 订单数据
    ship_address = "#{shipaddress.province}:#{shipaddress.city}:#{shipaddress.region}:#{shipaddress.address}:#{shipaddress.postcode}" # 省:市:区:详细地址:postcode邮编
    invoice_id = invoice.nil? ? nil : invoice.id

    total_price = 0.00  # 总价
    freight = 0.00  # 运费
    package_charge = 0.00  # 包装费

    payment_method = params[:payment_method]

    # order_status: {1: 未处理, 2: 已确定, 3: 已完成, 4: 已取消}
    # pay_status: {1: 未付款, 2: 已付款}
    # logistics_status: {0: 订单还未处理, 1: 备货中, 2: 已发货, 3: 已收货, 4: 已退货}
    order = Order.new(
      user_id: current_user.id,
      ship_address: ship_address,
      ship_method: params[:ship_method],
      payment_method: payment_method,
      invoice_id: invoice_id,
      total_price: total_price,
      buy_date: Time.now,
      order_status: 1,
      pay_status: 1,  # 未付款
      logistics_status: 0,
      receive_name: shipaddress.receive_name,
      mobile: shipaddress.mobile,
      tel: shipaddress.tel,
      supplier_id: current_user.profile.supplier_id,
      order_number: Order.generate_order_number,
    )
    # 商品列表
    products = params[:products]

    if !params[:is_product].blank? && params[:is_product].to_i == 1
      order.order_type = '普通订单'
      ProductOrder.transaction do
        Order.transaction do
          order.save!
          # 判断邀请码和分享链接, 并生成ABC关系
          invite_and_share_link_code(share_link_code, invite_code, current_user_profile, order)
          # product_order
          p_o_list = []
          products.each do |_, p|
            product_id = p[:product_id].to_i
            product_count = p[:product_count]
            product = Product.find(product_id)
            unit_price = product.price

            product_order = ProductOrder.new(
              order_id: order.id,
              product_id: product_id,
              product_count: product_count,
              unit_price: unit_price
            )
            p_o_list.push product_order

            total_price += unit_price.to_f * product_count.to_i
            total_price += product.fright.to_f
            freight += product.fright.to_f
          end

          total_price = total_price.round(2)

          # 计算积分兑换金钱
          total_price = integral_to_money(payment_method, total_price, current_user)

          p_o_list.each(&:save!)
          order.total_price = total_price
          order.freight = freight
          order.package_charge = package_charge
          order.save!
          render json: { status: 'success', msg: 'create order success', data: { order_number: order.order_number }  }
          return
        end
      end
    elsif !params[:is_group].blank? && params[:is_group].to_i == 1
      order.order_type = '团购订单'
      GroupOrder.transaction do
        Order.transaction do
          order.save!
          invite_and_share_link_code(share_link_code, invite_code, current_user_profile, order)
          # group_order
          p_o_list = []
          products.each do |_, p|
            product_id = p[:product_id].to_i
            product_count = p[:product_count]

            product = Product.find(product_id)
            group = product.group
            unit_price = group.price

            group.people += 1
            group.remain -= product_count.to_i
            group.save!

            group_order = GroupOrder.new(
              order_id: order.id,
              group_id: group.id,
              group_count: product_count,
              unit_price: unit_price
            )
            p_o_list.push group_order

            total_price += unit_price.to_f * product_count.to_i
            total_price += product.fright.to_f
            freight += product.fright.to_f
          end

          total_price = total_price.round(2)

          # 计算积分兑换金钱
          total_price = integral_to_money(payment_method, total_price, current_user)

          p_o_list.each(&:save!)
          order.total_price = total_price
          order.freight = freight
          order.package_charge = package_charge
          order.save!
          render json: { status: 'success', msg: 'create order success', data: { order_number: order.order_number }  }
          return
        end
      end
    elsif !params[:is_seckill].blank? && params[:is_seckill].to_i == 1
      order.order_type = '秒杀订单'
      SeckillOrder.transaction do
        Order.transaction do
          order.save!
          invite_and_share_link_code(share_link_code, invite_code, current_user_profile, order)
          # seckill_order
          p_o_list = []
          products.each do |_, p|
            product_id = p[:product_id].to_i
            product_count = p[:product_count]

            product = Product.find(product_id)
            seckill = product.seckill
            unit_price = seckill.price

            seckill.people += 1
            seckill.remain -= product_count.to_i
            seckill.save!

            seckill_order = SeckillOrder.new(
              order_id: order.id,
              seckill_id: seckill.id,
              seckill_count: product_count,
              unit_price: unit_price
            )
            p_o_list.push seckill_order

            total_price += unit_price.to_f * product_count.to_i
            total_price += product.fright.to_f
            freight += product.fright.to_f
          end

          total_price = total_price.round(2)

          # 计算积分兑换金钱
          total_price = integral_to_money(payment_method, total_price, current_user)

          p_o_list.each(&:save!)
          order.total_price = total_price
          order.freight = freight
          order.package_charge = package_charge
          order.save!
          render json: { status: 'success', msg: 'create order success', data: { order_number: order.order_number } }
          return
        end
      end
    else
      render json: { status: 'fail', msg: 'order params error' }
    end
  end

  # 待发货
  # order_status: {1: 未处理, 2: 已确定, 3: 已完成, 4: 已取消}
  # pay_status: {1: 未付款, 2: 已付款}
  # logistics_status: {0: 订单还未处理, 1: 备货中, 2: 已发货, 3: 已收货, 4: 已退货}
  def index_wait_ship
    @orders = Order.find_by_sql(["SELECT * FROM orders WHERE user_id = ? AND (order_status = 1 OR order_status = 2) AND pay_status = 2 AND (logistics_status = 0 OR logistics_status = 1) ORDER BY id DESC", current_user.id])
    # @orders = current_user.orders.where("(order_status = 1 OR order_status = 2) AND pay_status = 2 AND (logistics_status = 0 OR logistics_status = 1)")
  end

  # 带付款
  def index_wait_pay
    @orders = current_user.orders.where(pay_status: 1).order('id DESC')
  end

  # 待收货
  def index_wait_receive
    @orders = current_user.orders.where(order_status: 2, pay_status: 2, logistics_status: 2).order('id DESC')
  end

  # 历史订单
  def index_order_history
    @orders = current_user.orders.where(order_status: 3, pay_status: 2, logistics_status: 3).order('id DESC')
  end

  # 大转盘
  def big_wheel
    # 抽奖活动
    @prize_act = PrizeAct.where(prize_type: 'bigwheel', is_open: 1).last(1)[0]
    # 该抽奖活动的奖品
    @prizes = @prize_act.prize_configs if @prize_act
    if current_user
      # 当前用户抽奖剩余次数
      @prize_user_number = PrizeUserNumber.where(user_id: current_user.id, prize_act_id: @prize_act.id).first if @prize_act
      # 当前用户未领奖项
      @prize_users = PrizeUser.where(
        user_id: current_user.id,
        geted: 0
      )
    end
  end

  # ajax大转盘接口
  def big_wheel_ajax
    prize_act = PrizeAct.where(prize_type: 'bigwheel', is_open: 1).last(1)[0]

    prizes = prize_act.prize_configs
    prize_hash = {}
    prizes.each_with_index do |p, index|
      min = p.min.split(',')
      max = p.max.split(',')
      p.min = min if min.size > 1
      p.max = max if max.size > 1
      prize_hash[index] = p
    end
    prize_num = PrizeUserNumber.where(user_id: current_user.id,
                                      prize_act_id: prize_act.id).first
    @result = {}
    if prize_num.blank?
      prize_act.join_num += 1
      prize_act.save!
    end
    if !prize_num.nil? && prize_num.number == 0
      @result = {
        num: -1,
        prize_name: nil,
        angle: 0
      }
      render json: @result
      return
    end
    @result = get_result(prize_hash)
    render json: @result
  end

  # 刮刮乐
  def scratch_off
    # 抽奖活动
    @prize_act = PrizeAct.where(prize_type: 'scratchoff', is_open: 1).last(1)[0]
    # 该抽奖活动的奖品
    @prizes = @prize_act.prize_configs if @prize_act
    if current_user
      # 当前用户抽奖剩余次数
      @prize_user_number = PrizeUserNumber.where(user_id: current_user.id, prize_act_id: @prize_act.id).first if @prize_act
      # 当前用户未领奖项
      @prize_users = PrizeUser.where(
        user_id: current_user.id,
        geted: 0
      )
    end
  end

  # 刮刮乐ajax接口
  def scratch_off_ajax
    prize_act = PrizeAct.where(prize_type: 'scratchoff', is_open: 1).last(1)[0]

    prizes = prize_act.prize_configs
    prize_hash = {}
    prizes.each_with_index do |p, index|
      min = p.min.split(',')
      max = p.max.split(',')
      p.min = min if min.size > 1
      p.max = max if max.size > 1
      prize_hash[index] = p
    end
    prize_num = PrizeUserNumber.where(user_id: current_user.id,
                                      prize_act_id: prize_act.id).first

    @result = {}
    if prize_num.blank?
      prize_act.join_num += 1
      prize_act.save!
    end
    if !prize_num.nil? && prize_num.number == 0
      @result = {
        num: -1,
        prize_name: nil,
        angle: 0
      }
      render json: @result
      return
    end
    @result = get_result(prize_hash)
    render json: @result
  end

  # 提成记录
  def commission
    # array of all children, children's children, etc.
    @commissions = current_user.profile.descendants
    @results = []
    @commissions.each do |pro|
      Commission.where(user_id: current_user.id, from_user_id: pro.user.id).each do |c|
        @results.push(from_user: pro.user.username, money: c.commission_money)
      end
    end
  end

  private

  # 活取js sdk hash
  def init_share_hash(path)
    app_id = ENV['APP_ID']
    app_secret = ENV['APP_SECRET']
    access_token = nil
    jsapi_ticket = nil
    if $redis
      access_token = $redis.get('access_token')
      if access_token.blank?
        access_token_hash = WxExt::Api::Base.get_access_token(app_id, app_secret, 'client_credential')
        access_token = access_token_hash['access_token']
        $redis.set('access_token', access_token)
        $redis.expire('access_token', 7000)
      end
      jsapi_ticket = $redis.get('jsapi_ticket')
      if jsapi_ticket.blank?
        jsapi_ticket_hash = WxExt::Api::Js.get_jsapi_ticket(access_token)
        jsapi_ticket = jsapi_ticket_hash['ticket']
        $redis.set('jsapi_ticket', jsapi_ticket)
        $redis.expire('jsapi_ticket', 7000)
      end
    else
      access_token_hash = WxExt::Api::Base.get_access_token(app_id, app_secret, 'client_credential')
      access_token = access_token_hash['access_token']

      jsapi_ticket_hash = WxExt::Api::Js.get_jsapi_ticket(access_token)
      jsapi_ticket = jsapi_ticket_hash['ticket']
    end
    url = ENV['APP_JS_URL']
    url = 'http://' + url + path
    WxExt::Api::Js.get_jsapi_config(access_token, url, app_id, jsapi_ticket) unless access_token.nil? && jsapi_ticket.blank?
  end

  # 结果
  def get_result(prize_hash)
    result = {}
    hash = {}
    count = {}
    prize_hash.each do |_, value|
      hash[value.id] = value.chance
      count[value.id] = value.prize_inventory
    end
    rid = get_rand(hash, count) # 根据概率获取奖项id
    res = PrizeConfig.find rid # 中奖项

    prize_act = res.prize_act unless res.prize_act.nil?
    if prize_act
      if current_user
        prize_num = PrizeUserNumber.where(user_id: current_user.id,
                                          prize_act_id: prize_act.id).first
        if prize_num.nil?
          prize_num = PrizeUserNumber.new(
            user_id: current_user.id,
            number: prize_act.person_limit,
            prize_act_id: prize_act.id
          )
          prize_num.save!
        end

        if prize_num.number == 0 # 该用户剩余抽奖次数该用户剩余抽奖次数
          result[:num] = 0
          result[:prize_name] = nil
          result[:angle] = 0
        else
          prize_num.number -= 1
          prize_num.save!
          num = prize_num.number
          result[:num] = num

          min = res.min
          max = res.max

          if min.is_a? Array
            _size = min.size - 1
            i = rand(0.._size)
            _min = min[i].to_i
            _max = max[i].to_i
            result[:angle] = rand(_min.._max)
          else
            min = res.min.to_i
            max = res.max.to_i
            result[:angle] = rand(min..max)
          end
          result[:prize_name] = res.prize_name
        end
      else
        result[:num] = 0
        min = res.min
        max = res.max

        if min.is_a? Array
          _size = min.size - 1
          i = rand(0.._size)
          _min = min[i].to_i
          _max = max[i].to_i
          result[:angle] = rand(_min.._max)
        else
          min = res.min.to_i
          max = res.max.to_i
          result[:angle] = rand(min..max)
        end
        result[:prize_name] = res.prize_name
      end
      if res.prize_inventory == 0
        result[:num] = 0
        result[:prize_name] = nil
        result[:angle] = 0
      else
        res.prize_inventory -= 1
        res.save!
      end
      if current_user
        prize_user = PrizeUser.new(
          user_id: current_user.id,
          prize_config_id: res.id,
          geted: 0
        )
        prize_user.save!
      end
    end
    result
  end

  # 随机数生成，用户大转盘和刮刮乐
  def get_rand(pro_arr, pro_count)
    result = 0
    pro_sum = 0
    # 概率数组的总概率精度  获取库存不为0的
    pro_count.each do |key, val|
      if val == 0
        next
      else
        pro_sum += pro_arr[key]
      end
    end
    # 概率数组循环
    pro_arr.each do |key, val|
      if pro_count[key] == 0
        next
      else
        rand_num = rand(1..pro_sum) # 关键
        if rand_num <= val
          result = key
          break
        else
          pro_sum -= val
        end
      end
    end
    result
  end

  # 计算积分兑换金钱
  def integral_to_money(payment_method, total_price, current_user)
    if payment_method == 'integralpayment'
      integral = current_user.integral unless current_user.blank?
      integral_to_money = SiteConfig.where(key: 'integral_to_money_percent').first
      integral_to_money_percent = integral_to_money.val.to_i.round(2)/100

      amount = integral.amount.to_i unless integral.blank?

      if amount >= 100
        # 对分数进行求余
        remainder = amount % 100
        cal_amount = amount - remainder
        # 减去用户积分
        integral.amount = remainder
        integral.save!
        # 兑换后减去总价
        total_price -= cal_amount * integral_to_money_percent
      end
      total_price.round(2)
    end
  end

  # 处理订单中含有邀请码和分享链接的函数
  def invite_and_share_link_code(share_link_code, invite_code, current_user_profile, order)
    Rails.logger.info "share_link_code is #{share_link_code}"
    Rails.logger.info "invite_code is #{invite_code}"
    if current_user_profile.parent.blank?  # 不存在上家
      if !share_link_code.blank? && !invite_code.blank?
        # invite_code is more import
        parent_user = Profile.where(invite_code: invite_code).first
        unless parent_user.blank?
          current_user_profile.move_to_child_of(parent_user)
          parent_user.reload
          order.invite_code = invite_code
        end
      elsif !share_link_code.blank? || !invite_code.blank?
        # share_link_code
        unless share_link_code.blank?
          parent_user = Profile.where(share_link_code: share_link_code).first
          unless parent_user.blank?
            current_user_profile.move_to_child_of(parent_user)
            parent_user.reload
            order.share_link_code = share_link_code
          end
        end

        # invite_code
        unless invite_code.blank?
          parent_user = Profile.where(invite_code: invite_code).first
          unless parent_user.blank?
            current_user_profile.move_to_child_of(parent_user)
            parent_user.reload
            order.invite_code = invite_code
          end
        end
      end
    end
  end
end
