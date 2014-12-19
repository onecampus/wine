class PrizeUsersController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_prize_user, only: [:show, :edit, :update, :destroy]

  def index
    @prize_users = PrizeUser.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@prize_users)
  end

  def show
    respond_with(@prize_user)
  end

  def new
    @prize_user = PrizeUser.new
    respond_with(@prize_user)
  end

  def edit
  end

  def create
    @prize_user = PrizeUser.new(prize_user_params)
    flash[:notice] = 'PrizeUser was successfully created.' if @prize_user.save
    respond_with(@prize_user)
  end

  def update
    flash[:notice] = 'PrizeUser was successfully updated.' if @prize_user.update(prize_user_params)
    respond_with(@prize_user)
  end

  def destroy
    @prize_user.geted = 1
    @prize_user.save
    respond_with(@prize_user)
  end

  private
    def set_prize_user
      @prize_user = PrizeUser.find(params[:id])
    end

    def prize_user_params
      params.require(:prize_user).permit(:user_id, :prize_config_id)
    end
end
