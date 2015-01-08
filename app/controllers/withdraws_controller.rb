class WithdrawsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_withdraw, only: [:show, :edit, :update, :destroy, :ok_withdraw]
  skip_before_filter :verify_authenticity_token, only: [:ok_withdraw]

  def ok_withdraw
    @withdraw.draw_status = 1
    if @withdraw.save
      render json: { status: 'success', msg: 'action draw success' }
    else
      render json: { status: 'failed', msg: 'action draw failed' }
    end
  end

  def index
    @withdraws = Withdraw.where(draw_status: 0).paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@withdraws)
  end

  def show
    respond_with(@withdraw)
  end

  def new
    @withdraw = Withdraw.new
    respond_with(@withdraw)
  end

  def edit
  end

  def create
    @withdraw = Withdraw.new(withdraw_params)
    @withdraw.draw_status = 0
    flash[:notice] = 'Withdraw was successfully created.' if @withdraw.save
    respond_with(@withdraw)
  end

  def update
    flash[:notice] = 'Withdraw was successfully updated.' if @withdraw.update(withdraw_params)
    @withdraw.draw_status = 0
    @withdraw.save
    respond_with(@withdraw)
  end

  def destroy
    @withdraw.destroy
    respond_with(@withdraw)
  end

  private
    def set_withdraw
      @withdraw = Withdraw.find(params[:id])
    end

    def withdraw_params
      params.require(:withdraw).permit(:user_id, :bank_card, :alipay, :we_chat_payment, :draw_type, :draw_money, :draw_status)
    end
end
