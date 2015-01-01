class GroupsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@groups)
  end

  def show
    respond_with(@group)
  end

  def new
    @group = Group.new
    respond_with(@group)
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
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
      params.require(:group).permit(:product_id, :start_time, :end_time, :limit_people_count, :limit_product_count, :description, :price, :saveup, :discount, :people)
    end
end
