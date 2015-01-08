class OrdersController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_order, only: [:show, :edit, :update, :destroy, :sure_order, :ship_order, :receive_order, :ok_order]

  def index
    @orders = Order.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@orders)
  end

  def show
    respond_with(@order)
  end

  def new
    @order = Order.new
    respond_with(@order)
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    flash[:notice] = '订单创建成功.' if @order.save
    respond_with(@order)
  end

  def update
    flash[:notice] = '订单更新成功.' if @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  # order_status: {1: 未处理, 2: 已确定, 3: 已完成, 4: 已取消}
  # pay_status: {1: 未付款, 2: 已付款}
  # logistics_status: {0: 订单还未处理, 1: 备货中, 2: 已发货, 3: 已收货, 4: 已退货}
  def index_orders_unsure
    @orders = Order.where(order_status: 1, pay_status: 2, logistics_status: 0).paginate(
      page: params[:page],
      per_page: 10
    ).order('id DESC')
  end

  # 确定订单
  def sure_order
    @order.order_status = 2
    @order.logistics_status = 1
    @order.save
    flash[:notice] = '确定成功, 该订单已进入备货阶段'
    redirect_to action: :index_orders_unsure
  end

  def index_orders_wait_ship
    @orders = Order.where(order_status: 2, pay_status: 2, logistics_status: 1).paginate(
      page: params[:page],
      per_page: 10
    ).order('id DESC')
  end

  def ship_order
    @order.logistics_status = 2
    @order.save
    flash[:notice] = '发货标记成功, 该订单已进入待收货阶段'
    redirect_to action: :index_orders_wait_ship
  end

  def index_orders_already_ship
    @orders = Order.where(order_status: 2, pay_status: 2, logistics_status: 2).paginate(
      page: params[:page],
      per_page: 10
    ).order('id DESC')
  end

  def receive_order
    @order.logistics_status = 3
    @order.save
    flash[:notice] = '收货标记成功, 该订单已进入待完成阶段'
    redirect_to action: :index_orders_already_ship
  end

  def index_orders_already_receive
    @orders = Order.where(order_status: 2, pay_status: 2, logistics_status: 3).paginate(
      page: params[:page],
      per_page: 10
    ).order('id DESC')
  end

  def ok_order
    @order.order_status = 3
    @order.save
    buyer = @order.user
    commissioner = nil
    if !@order.invite_code.blank?
      commissioner_profile = Profile.where(invite_code: @order.invite_code).first
      commissioner = commissioner_profile.user
    elsif !@order.share_link_code.blank?
      commissioner_profile = Profile.where(share_link_code: @order.share_link_code).first
      commissioner = commissioner_profile.user
    end
    vritualcard = commissioner.vritualcard
    commissioner_money = vritualcard.money.to_f
    commissioner_money += @order.total_price.to_f * 10%
    vritualcard.money = commissioner_money.round(2)
    vritualcard.save!
    flash[:notice] = '该订单已经完成'
    redirect_to action: :index_orders_already_ok
  end

  def index_orders_already_ok
    @orders = Order.where(order_status: 3, pay_status: 2, logistics_status: 3).paginate(
      page: params[:page],
      per_page: 10
    ).order('id DESC')
  end

  def index_orders_back
    @orders = Order.where(order_status: 2, pay_status: 2, logistics_status: 4).paginate(
      page: params[:page],
      per_page: 10
    ).order('id DESC')
  end

  def index_orders_canceled
    @orders = Order.where(order_status: 3, pay_status: 2).paginate(
      page: params[:page],
      per_page: 10
    ).order('id DESC')
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:invoice_id, :user_id, :order_number, :ship_address, :ship_method, :payment_method, :freight, :package_charge, :total_price, :buy_date, :order_status, :pay_status, :logistics_status, :operator, :cancel_reason, :weixin_open_id, :receive_name, :mobile, :tel, :supplier_id, :order_type)
  end
end
