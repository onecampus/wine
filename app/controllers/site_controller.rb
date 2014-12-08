##
# This class is a controller for customer from weixin brower.
class SiteController < CustomerController
  layout 'customer'

  skip_before_filter :authenticate_user!, only: [:index, :index_cats,
                                                 :show_product, :index_comments,
                                                 :index_search_result]
  # skip_before_filter :verify_authenticity_token, only: [:]

  def index
    @recommend_products = Product.last 8
  end

  def index_cats
    @cats = Cat.all
  end

  def show_product
    @product = Product.find params[:id]
  end

  def new_comment
    @product = Product.find params[:id]
  end

  def create_comment
    @product = Product.find params[:id]
    @user_who_commented = current_user
    @comment = Comment.build_from(@product, @user_who_commented.id, params[:content])
    if @comment.save
      flash.now[:alert] = '创建成功'
      redirect_to action: :index_comments
    else
      flash.now[:alert] = '创建失败'
      render action: :new_comment
    end
  end

  def index_comments
    @product = Product.find params[:id]
    @comments = @product.comment_threads
  end

  def new_ship_address
    @ship_address = Shipaddress.new(params[:shipaddress])
  end

  def index_ship_address
  end

  def index_shopping_cart
  end

  def user_center
  end

  def index_search_result
  end

  def show_vip_card
  end

  def commission
  end
end
