##
# This class is cat.
class CatsController < ApplicationController
  authorize_resource

  respond_to :json, :html
  before_action :set_cat, only: [:show, :edit, :update, :destroy]

  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode

  def nested_options
    @categories = Cat.nested_set.select('id, title, content, parent_id')
  end

  def manage
    @categories = Cat.nested_set.select('id, title, content, parent_id').all
  end

  def node_manage
    @root  = Cat.root
    @categories = @root.self_and_descendants.nested_set.select('id, title, content, parent_id')
    render template: 'cats/manage'
  end

  def expand
    @categories = Cat.nested_set.roots.select('id, title, content, parent_id')
  end

  def index
    @cats = Cat.all.paginate(page: params[:page],
                             per_page: 10).order('id DESC')
    respond_with(@cats)
  end

  def show
    respond_with(@cat)
  end

  def new
    @cat = Cat.new
    respond_with(@cat)
  end

  def edit
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.title = cat_params[:name]
    @cat.content = cat_params[:name]
    @cat.secret_field = cat_params[:name]

    @cat.save
    respond_with(@cat)
  end

  def update
    cat_params[:title] = cat_params[:name]
    cat_params[:content] = cat_params[:name]
    cat_params[:secret_field] = cat_params[:name]
    @cat.update(cat_params)
    respond_with(@cat)
  end

  def destroy
    if @cat.products != []
      flash[:notice] = '该分类下包含其他商品，不能删除'
    else
      @cat.destroy
      flash[:notice] = '分类删除成功'
    end
    respond_to do |format|
      format.html { redirect_to cats_url }
      format.json { head :no_content }
    end
  end

  private

  def set_cat
    @cat = Cat.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit(:name, :img)
  end
end
