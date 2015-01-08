class SeckillsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_seckill, only: [:show, :edit, :update, :destroy]

  def index
    @seckills = Seckill.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@seckills)
  end

  def show
    respond_with(@seckill)
  end

  def new
    @products = Product.all
    @seckill = Seckill.new
    respond_with(@seckill)
  end

  def edit
    @products = Product.all
  end

  def create
    @seckill = Seckill.new(seckill_params)
    @seckill.people = 0
    flash[:notice] = '秒杀活动创建成功' if @seckill.save
    respond_with(@seckill)
  end

  def update
    flash[:notice] = '秒杀活动更新成功' if @seckill.update(seckill_params)
    respond_with(@seckill)
  end

  def destroy
    @seckill.destroy
    respond_with(@seckill)
  end

  private
    def set_seckill
      @seckill = Seckill.find(params[:id])
    end

    def seckill_params
      params.require(:seckill).permit(:product_id, :start_time, :end_time, :limit_people_count, :limit_product_count, :description, :price, :saveup, :discount)
    end
end
