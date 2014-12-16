class ProductOrdersController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_product_order, only: [:show, :edit, :update, :destroy]

  def index
    @product_orders = ProductOrder.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@product_orders)
  end

  def show
    respond_with(@product_order)
  end

  def new
    @product_order = ProductOrder.new
    respond_with(@product_order)
  end

  def edit
  end

  def create
    @product_order = ProductOrder.new(product_order_params)
    flash[:notice] = 'ProductOrder was successfully created.' if @product_order.save
    respond_with(@product_order)
  end

  def update
    flash[:notice] = 'ProductOrder was successfully updated.' if @product_order.update(product_order_params)
    respond_with(@product_order)
  end

  def destroy
    @product_order.destroy
    respond_with(@product_order)
  end

  private
    def set_product_order
      @product_order = ProductOrder.find(params[:id])
    end

    def product_order_params
      params.require(:product_order).permit(:order_id, :product_id, :product_count, :unit_price)
    end
end
