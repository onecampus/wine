class CommissionsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_commission, only: [:show, :edit, :update, :destroy]

  def index
    @commissions = Commission.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@commissions)
  end

  def show
    respond_with(@commission)
  end

  def new
    @commission = Commission.new
    respond_with(@commission)
  end

  def edit
  end

  def create
    @commission = Commission.new(commission_params)
    flash[:notice] = 'Commission was successfully created.' if @commission.save
    respond_with(@commission)
  end

  def update
    flash[:notice] = 'Commission was successfully updated.' if @commission.update(commission_params)
    respond_with(@commission)
  end

  def destroy
    @commission.destroy
    respond_with(@commission)
  end

  private
    def set_commission
      @commission = Commission.find(params[:id])
    end

    def commission_params
      params.require(:commission).permit(:user_id, :order_id, :commission_money, :percent)
    end
end
