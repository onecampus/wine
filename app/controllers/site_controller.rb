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
                                                 :show_group]
  skip_before_filter :verify_authenticity_token, only: [:create_order,
                                                        :big_wheel_ajax,
                                                        :scratch_off_ajax,
                                                        :create_ship_address_via_ajax,
                                                        :create_invoice_via_ajax]

  def index
    @site_config1 = SiteConfig.where(key: 'CustomerIndexImgConfigKey1', config_type: 'CustomerIndexImgConfig').first
    @site_config2 = SiteConfig.where(key: 'CustomerIndexImgConfigKey2', config_type: 'CustomerIndexImgConfig').first
    @site_config3 = SiteConfig.where(key: 'CustomerIndexImgConfigKey3', config_type: 'CustomerIndexImgConfig').first
  end

  def index_cats
    @cats = Cat.all
  end

  def index_cat_products
    @cat = Cat.find params[:cid]
    @cat_products = @cat.products
  end

  def show_product
    @product = Product.find params[:id]
  end

  def index_groups_seckills
    @groups = Group.all
  end

  def show_group
    @group = Group.find params[:id]
  end

  def show_seckill
    @seckill = nil
  end

  def new_comment
    @product = Product.find params[:id]
  end

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

  def index_comments
    @product = Product.find params[:id]
    @comments = @product.comment_threads
  end

  def new_ship_address
    @shipaddress = Shipaddress.new(params[:shipaddress])
  end

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

  def index_ship_address
    @shipaddresses = current_user.shipaddresses
  end

  def index_shopping_cart
  end

  def user_center
    @user = current_user
  end

  def index_search_result
    q = params[:q]
    if q && q != ''
      @products = Product.where('name LIKE ?', "%#{q}%")
    else
      @products = []
    end
  end

  def show_vip_card
    @user = current_user
  end

  def order_settlement
    @shipaddresses = current_user.shipaddresses
    @invoices = current_user.invoices
  end

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
    share_link_code = params[:share_link_code]
    invite_code = params[:invite_code]
    current_user_profile = current_user.profile

    if !share_link_code.blank? && !invite_code.blank?
      # invite_code is more import
      unless invite_code.blank?
        parent_user = Profile.where(invite_code: invite_code).first
        unless parent_user.nil?
          current_user_profile.move_to_child_of(parent_user)
          parent_user.reload
        end
      end
    elsif !share_link_code.blank? || !invite_code.blank?
      # share_link_code
      unless share_link_code.blank?
        parent_user = Profile.where(share_link_code: share_link_code).first
        unless parent_user.nil?
          current_user_profile.move_to_child_of(parent_user)
          parent_user.reload
        end
      end

      # invite_code
      unless invite_code.blank?
        parent_user = Profile.where(invite_code: invite_code).first
        unless parent_user.nil?
          current_user_profile.move_to_child_of(parent_user)
          parent_user.reload
        end
      end
    end

    # 之前有没有购买过东西, 如果没有, 那么是第一次购买, 生成 invite_code
    old_orders = current_user.orders

    # shipaddress
    shipaddress = Shipaddress.find params[:ship_address_id]
    # invoice
    invoice = nil
    invoice = Invoice.find(params[:invoice_id]) unless params[:invoice_id].blank?

    # order
    ship_address = "#{shipaddress.province}:#{shipaddress.city}:#{shipaddress.region}:#{shipaddress.address}:#{shipaddress.postcode}" # 省:市:区:详细地址:postcode邮编
    invoice_id = invoice.nil? ? nil : invoice.id

    total_price = 0.00
    freight = 0.00
    package_charge = 0.00

    order = Order.new(
      user_id: current_user.id,
      ship_address: ship_address,
      ship_method: params[:ship_method],
      payment_method: params[:payment_method],
      invoice_id: invoice_id,
      total_price: total_price,
      buy_date: Time.now,
      order_status: 1,
      pay_status: 2,
      logistics_status: 0,
      weixin_open_id: '',
      receive_name: shipaddress.receive_name,
      mobile: shipaddress.mobile,
      tel: shipaddress.tel,
      supplier_id: current_user.profile.supplier_id,
      order_type: '普通订单'
    )
    products = params[:products]

    if !params[:is_product].blank?
      order.order_type = '普通订单'
      ProductOrder.transaction do
        Order.transaction do
          if old_orders.blank?
            invite_code = User.generate_invite_code
            current_user_profile.invite_code = invite_code
            current_user_profile.save!
          end
          order.save!
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

          p_o_list.each(&:save!)
          order.total_price = total_price
          order.freight = freight
          order.package_charge = package_charge
          order.save!
          render json: { status: 'success', msg: 'create order success' }
          return
        end
      end
    elsif !params[:is_group].blank?
      order.order_type = '团购订单'
      GroupOrder.transaction do
        Order.transaction do
          if old_orders.blank?
            invite_code = User.generate_invite_code
            current_user_profile.invite_code = invite_code
            current_user_profile.save!
          end
          order.save!
          # group_order
          p_o_list = []
          products.each do |_, p|
            product_id = p[:product_id].to_i
            product_count = p[:product_count]

            product = Product.find(product_id)
            group = product.group
            unit_price = group.price

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

          p_o_list.each(&:save!)
          order.total_price = total_price
          order.freight = freight
          order.package_charge = package_charge
          order.save!
          render json: { status: 'success', msg: 'create order success' }
          return
        end
      end
    elsif !params[:is_seckill].blank?
      order.order_type = '秒杀订单'
      SeckillOrder.transaction do
        Order.transaction do
          if old_orders.blank?
            invite_code = User.generate_invite_code
            current_user_profile.invite_code = invite_code
            current_user_profile.save!
          end
          order.save!
          # seckill_order
          p_o_list = []
          products.each do |_, p|
            product_id = p[:product_id].to_i
            product_count = p[:product_count]

            product = Product.find(product_id)
            seckill = product.seckill
            unit_price = seckill.price

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

          p_o_list.each(&:save!)
          order.total_price = total_price
          order.freight = freight
          order.package_charge = package_charge
          order.save!
          render json: { status: 'success', msg: 'create order success' }
          return
        end
      end
    end
  end

  # order_status: {1: 未处理, 2: 已确定, 3: 已完成, 4: 已取消}
  # pay_status: {1: 未付款, 2: 已付款}
  # logistics_status: {0: 订单还未处理, 1: 备货中, 2: 已发货, 3: 已收货, 4: 已退货}
  def index_wait_ship
    @orders = Order.find_by_sql(["SELECT * FROM orders WHERE user_id = ? AND (order_status = 1 OR order_status = 2) AND pay_status = 2 AND (logistics_status = 0 OR logistics_status = 1) ORDER BY id DESC", current_user.id])
    # @orders = current_user.orders.where("(order_status = 1 OR order_status = 2) AND pay_status = 2 AND (logistics_status = 0 OR logistics_status = 1)")
  end

  def index_wait_pay
    @orders = current_user.orders.where(pay_status: 1).order('id DESC')
  end

  def index_wait_receive
    @orders = current_user.orders.where(order_status: 2, pay_status: 2, logistics_status: 2).order('id DESC')
  end

  def index_order_history
    @orders = current_user.orders.where(order_status: 3, pay_status: 2, logistics_status: 3).order('id DESC')
  end

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

  def commission
  end

  private

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
            puts '--' * 20
            puts 'i= ' + i.to_s
            puts _min
            puts _max
            puts result[:angle]
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
end
