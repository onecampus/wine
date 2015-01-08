class SeckillsController < ApplicationController
  before_action :set_seckill, only: [:show, :edit, :update, :destroy]

  def index
    @seckills = Seckill.all
    respond_with(@seckills)
  end

  def show
    respond_with(@seckill)
  end

  def new
    @seckill = Seckill.new
    respond_with(@seckill)
  end

  def edit
  end

  def create
    @seckill = Seckill.new(seckill_params)
    flash[:notice] = 'Seckill was successfully created.' if @seckill.save
    respond_with(@seckill)
  end

  def update
    flash[:notice] = 'Seckill was successfully updated.' if @seckill.update(seckill_params)
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
      params.require(:seckill).permit(:product_id, :start_time, :end_time, :limit_people_count, :limit_product_count, :description, :price, :saveup, :discount, :people)
    end
end
