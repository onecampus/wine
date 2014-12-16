class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.all
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
    flash[:notice] = 'Order was successfully created.' if @order.save
    respond_with(@order)
  end

  def update
    flash[:notice] = 'Order was successfully updated.' if @order.update(order_params)
    respond_with(@order)
  end

  def destroy
    @order.destroy
    respond_with(@order)
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:invoice_id, :user_id, :order_number, :ship_address, :ship_method, :payment_method, :freight, :package_charge, :total_price, :buy_date, :order_status, :pay_status, :logistics_status, :operator, :cancel_reason, :weixin_open_id, :receive_name, :mobile, :tel, :supplier_id, :order_type)
    end
end
