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
                                                 :index_order_history]
  skip_before_filter :verify_authenticity_token, only: [:create_order]

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

  def create_order
    # shipaddress
    ship_address_id = params[:ship_address_id]
    shipaddress = Shipaddress.find ship_address_id

    # invoice
    has_invoice_id = params[:has_invoice_id]
    if has_invoice_id == 0
    elsif has_invoice_id == 1
      rise = params[:rise] # 抬头
      content = params[:content] # 发票内容
      invoice = Invoice.new(rise: rise, content: content)
    else
      render json: { status: 'falied', msg: 'has_invoice_id is not 0 or 1',
                     data: '' }
      return
    end

    # order
    ship_address = "#{shipaddress.province}:#{shipaddress.city}:#{shipaddress.region}:#{shipaddress.address}:#{shipaddress.postcode}" # 省:市:区:详细地址:postcode邮编
    ship_method = params[:ship_method] # 送货方式
    payment_method = params[:payment_method] # 支付方式
    unless invoice.nil?
      invoice_id = invoice.id
    end

    user_id = current_user.id
    total_price = unit_price.to_i * product_count.to_i # 总价,通过计算获得
    buy_date = Time.now # 购买日期
    order_status = '未处理' # 未处理，已提交，已取消，已退货
    pay_status = '未付款' # 未付款，已付款
    logistics_status = '未备货' # 未备货,已备货，已发货，已收货
    weixin_open_id = ''
    receive_name = shipaddress.receive_name # 收货人姓名
    mobile = shipaddress.mobile
    tel = shipaddress.tel
    supplier_id = current_user.customer.supplier_id # 渠道商id
    order_type = '普通订单' # 普通订单，团购订单
    order = Order.new(
      user_id: user_id,
      ship_address: ship_address,
      ship_method: ship_method,
      payment_method: payment_method,
      invoice_id: invoice_id,
      total_price: total_price,
      buy_date: buy_date,
      order_status: order_status,
      pay_status: pay_status,
      logistics_status: logistics_status,
      weixin_open_id: weixin_open_id,
      receive_name: receive_name,
      mobile: mobile,
      tel: tel,
      supplier_id: supplier_id,
      order_type: order_type
    )

    # product_order
    order_id = order.id
    product_count = params[:product_count]
    product_id = params[:product_id]
    product = Product.find product_id
    unit_price = product.price

    product_order = ProductOrder.new(order_id: order_id, product_id: product_id,
                                     product_count: product_count,
                                     unit_price: unit_price)

    Invoice.transaction do
      Order.transaction do
        ProductOrder.transaction do
          invoice.save!
          order.save!
          product_order.save!
          render json: { status: 'success', msg: 'create order success',
                         data: '' }
          return
        end
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

  def commission
  end
end
