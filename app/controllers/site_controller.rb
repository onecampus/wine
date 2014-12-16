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
                                                 :create_order]
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
    shipaddress = Shipaddress.find params[:ship_address_id]

    # invoice
    invoice = nil
    has_invoice_id = params[:has_invoice_id].to_i
    if has_invoice_id == 0
    elsif has_invoice_id == 1
      invoice = Invoice.new(rise: params[:invoice][:rise], content: params[:invoice][:content])
    else
      render json: { status: 'falied', msg: 'has_invoice_id is not 0 or 1',
                     data: '' }
      return
    end

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

    Invoice.transaction do
      ProductOrder.transaction do
        Order.transaction do
          invoice.save!
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
