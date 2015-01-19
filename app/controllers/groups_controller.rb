class GroupsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@groups)
  end

  def show
    @products = Product.all
    respond_with(@group)
  end

  def new
    @products = Product.all
    @group = Group.new
    respond_with(@group)
  end

  def edit
    @products = Product.all
  end

  def create
    @group = Group.new(group_params)
    @group.people = 0
    @group.remain = @group.limit_product_count
    flash[:notice] = 'Group was successfully created.' if @group.save
    respond_with(@group)
  end

  def update
    flash[:notice] = 'Group was successfully updated.' if @group.update(group_params)
    respond_with(@group)
  end

  def destroy
    @group.destroy
    respond_with(@group)
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:product_id, :start_time, :end_time, :limit_people_count, :limit_product_count, :description, :price, :saveup, :discount, :limit_per_person, :is_commission)
  end
end
