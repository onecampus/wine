##
# This class is a controller for customer from weixin brower.
class SiteController < CustomerController
  layout 'customer'

  skip_before_filter :authenticate_user!, only: [:index, :index_cats,
                                                 :show_product, :index_comments,
                                                 :index_search_result,
                                                 :index_cat_products,
                                                 :index_wait_ship,
                                                 :index_wait_pay,
                                                 :index_wait_receive,
                                                 :index_order_history,
                                                 :create_order,
                                                 :big_whell_ajax]
  skip_before_filter :verify_authenticity_token, only: [:create_order,
                                                        :big_whell_ajax]

  def index
    @recommend_products = Product.last 8
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
  end

  def create_invoice_via_ajax
    @invoice = Invoice.new(rise: params[:rise], content: params[:content])
    if @invoice.save
      render json: { status: 'success', msg: 'create invoice success.',
                     data: @invoice.id }
    else
      render json: { status: 'failed', msg: 'create invoice failed.' }
    end
  end

  def create_order
    # shipaddress
    shipaddress = Shipaddress.find params[:ship_address_id]
    # invoice
    invoice = nil
    invoice = Invoice.find(params[:invoice_id]) unless params[:invoice_id].blank?

    # order
    ship_address = "#{shipaddress.province}:#{shipaddress.city}:#{shipaddress.region}:#{shipaddress.address}:#{shipaddress.postcode}" # 省:市:区:详细地址:postcode邮编
    invoice_id = invoice.nil? ? nil : invoice.id

    products = params[:products]
    total_price = 0.00

    order = Order.new(
      user_id: current_user.id,
      ship_address: ship_address,
      ship_method: params[:ship_method],
      payment_method: params[:payment_method],
      invoice_id: invoice_id,
      total_price: total_price,
      buy_date: Time.now,
      order_status: '未处理',
      pay_status: '未付款',
      logistics_status: '未备货',
      weixin_open_id: '',
      receive_name: shipaddress.receive_name,
      mobile: shipaddress.mobile,
      tel: shipaddress.tel,
      supplier_id: current_user.profile.supplier_id,
      order_type: '普通订单'
    )

    ProductOrder.transaction do
      Order.transaction do
        order.save!

        # product_order
        p_o_list = []
        products.each do |_, p|
          product_id = p[:product_id].to_i
          product = Product.find(product_id)
          unit_price = product.price
          product_count = p[:product_count].to_i

          product_order = ProductOrder.new(
            order_id: order.id,
            product_id: product_id,
            product_count: product_count,
            unit_price: product.price
          )
          p_o_list.push product_order

          total_price += unit_price.to_f * product_count
        end

        total_price = total_price.round(2)

        p_o_list.each(&:save!)
        order.total_price = total_price
        order.save!
        render json: { status: 'success', msg: 'create order success' }
        return
      end
    end
  end

  def index_wait_ship
  end

  def index_wait_pay
  end

  def index_wait_receive
  end

  def index_order_history
  end

  def big_wheel
  end

  def big_whell_ajax
    prizes = PrizeConfig.where(prize_act_id: 1)
    prize_hash = {}
    prizes.each_with_index do |p, index|
      min = p.min.split(',')
      max = p.max.split(',')
      p.min = min if min.size > 1
      p.max = max if max.size > 1
      prize_hash[index] = p
    end

    result = get_result(prize_hash)
    render json: result
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
        num = prize_num.number -= 1
        prize_num.save!
        result[:num] = num

        min = res.min
        max = res.max

        if min.is_a? Array
          i = rand(0..(min.size - 1))
          result[:angle] = rand(min[i]..max[i])
        else
          min = res.min.to_i
          max = res.max.to_i
          result[:angle] = rand(min..max)
        end
        result[:prize_name] = res.prize_name
      end
      res.prize_inventory -= 1
      res.save!
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
