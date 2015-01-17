class InventoriesController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.has_role? :admin
      @inventories = Inventory.all.paginate(page: params[:page],
                                            per_page: 10).order('id DESC')
    else
      @inventories = current_user.inventories.paginate(page: params[:page],
                                                       per_page: 10).order('id DESC')
    end
  end

  def show
    respond_with(@inventory)
  end

  def new
    @inventory = Inventory.new
  end

  def edit
  end

  def create
    inventory_params[:user_id] = current_user.id
    @inventory = Inventory.new(inventory_params)
    flash[:notice] = 'Inventory was successfully created.' if @inventory.save
    respond_with(@inventory)
  end

  def update
    flash[:notice] = '库存更新成功' if @inventory.update(inventory_params)
    respond_with(@inventory)
  end

  def destroy
    @inventory.destroy
    respond_with(@inventory)
  end

  private

    def set_inventory
      @inventory = Inventory.find(params[:id])
    end

    def inventory_params
      params.require(:inventory).permit(:product_id, :amount)
    end
end
