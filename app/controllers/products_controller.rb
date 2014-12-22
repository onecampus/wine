class ProductsController < ApplicationController
  authorize_resource
  respond_to :json, :html
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all.paginate(page: params[:page],
                                     per_page: 10).order('id DESC')
    respond_with(@products)
  end

  def show
    respond_with(@product)
  end

  def new
    @product = Product.new
    @categories = Cat.nested_set.select('id, title, content, parent_id')
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    flash[:notice] = '商品创建成功.' if @product.save

    @inventory = Inventory.create(user_id: current_user.id,
                                  product_id: @product.id,
                                  amount: 0)
    respond_with(@product)
  end

  def update
    flash[:notice] = '商品更新成功.' if @product.update(product_params)
    respond_with(@product)
  end

  def destroy
    if @product.orders != []
      flash[:notice] = '该商品下包含订单，不能删除'
    else
      @product.destroy
      @product.inventories.each do |i|
        i.destroy
      end
      flash[:notice] = '商品删除成功'
    end
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private

    def set_product
      @product = Product.find(params[:id])
      @categories = Cat.nested_set.select('id, title, content, parent_id')
    end

    def product_params
      params.require(:product).permit(:name, :price, :img, :cat_id,
                                      :description, :brand, :expiration_date,
                                      :country, :package_type,
                                      :product_model, :status, :profit,
                                      :vip_price, :is_new, :is_boutique,
                                      :unit, :fright)
    end
end
