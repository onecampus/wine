class PrizeUserNumbersController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_prize_user_number, only: [:show, :edit, :update, :destroy]

  def index
    @prize_user_numbers = PrizeUserNumber.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@prize_user_numbers)
  end

  def show
    respond_with(@prize_user_number)
  end

  def new
    @prize_user_number = PrizeUserNumber.new
    respond_with(@prize_user_number)
  end

  def edit
  end

  def create
    @prize_user_number = PrizeUserNumber.new(prize_user_number_params)
    flash[:notice] = 'PrizeUserNumber was successfully created.' if @prize_user_number.save
    respond_with(@prize_user_number)
  end

  def update
    flash[:notice] = 'PrizeUserNumber was successfully updated.' if @prize_user_number.update(prize_user_number_params)
    respond_with(@prize_user_number)
  end

  def destroy
    @prize_user_number.destroy
    respond_with(@prize_user_number)
  end

  private
    def set_prize_user_number
      @prize_user_number = PrizeUserNumber.find(params[:id])
    end

    def prize_user_number_params
      params.require(:prize_user_number).permit(:user_id, :number, :prize_act_id)
    end
end
