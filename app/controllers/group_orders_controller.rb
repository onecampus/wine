class GroupOrdersController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_group_order, only: [:show, :edit, :update, :destroy]

  def index
    @group_orders = GroupOrder.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@group_orders)
  end

  def show
    respond_with(@group_order)
  end

  def new
    @group_order = GroupOrder.new
    respond_with(@group_order)
  end

  def edit
  end

  def create
    @group_order = GroupOrder.new(group_order_params)
    flash[:notice] = 'GroupOrder was successfully created.' if @group_order.save
    respond_with(@group_order)
  end

  def update
    flash[:notice] = 'GroupOrder was successfully updated.' if @group_order.update(group_order_params)
    respond_with(@group_order)
  end

  def destroy
    @group_order.destroy
    respond_with(@group_order)
  end

  private
    def set_group_order
      @group_order = GroupOrder.find(params[:id])
    end

    def group_order_params
      params.require(:group_order).permit(:order_id, :group_id, :group_count, :unit_price)
    end
end
