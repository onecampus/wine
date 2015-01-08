class SeckillOrdersController < ApplicationController
  before_action :set_seckill_order, only: [:show, :edit, :update, :destroy]

  def index
    @seckill_orders = SeckillOrder.all
    respond_with(@seckill_orders)
  end

  def show
    respond_with(@seckill_order)
  end

  def new
    @seckill_order = SeckillOrder.new
    respond_with(@seckill_order)
  end

  def edit
  end

  def create
    @seckill_order = SeckillOrder.new(seckill_order_params)
    flash[:notice] = 'SeckillOrder was successfully created.' if @seckill_order.save
    respond_with(@seckill_order)
  end

  def update
    flash[:notice] = 'SeckillOrder was successfully updated.' if @seckill_order.update(seckill_order_params)
    respond_with(@seckill_order)
  end

  def destroy
    @seckill_order.destroy
    respond_with(@seckill_order)
  end

  private
    def set_seckill_order
      @seckill_order = SeckillOrder.find(params[:id])
    end

    def seckill_order_params
      params.require(:seckill_order).permit(:order_id, :seckill_id, :seckill_count, :unit_price)
    end
end
