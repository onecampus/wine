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
    flash[:notice] = 'Product was successfully created.' if @product.save

    @inventory = Inventory.create(user_id: current_user.id,
                                  product_id: @product.id,
                                  amount: 0)
    respond_with(@product)
  end

  def update
    flash[:notice] = 'Product was successfully updated.' if @product.update(product_params)
    respond_with(@product)
  end

  def destroy
    @product.destroy
    respond_with(@product)
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
                                      :unit)
    end
end
