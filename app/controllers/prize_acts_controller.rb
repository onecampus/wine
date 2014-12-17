class PrizeActsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_prize_act, only: [:show, :edit, :update, :destroy]

  def index
    @prize_acts = PrizeAct.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@prize_acts)
  end

  def show
    respond_with(@prize_act)
  end

  def new
    @prize_act = PrizeAct.new
    respond_with(@prize_act)
  end

  def edit
  end

  def create
    @prize_act = PrizeAct.new(prize_act_params)
    flash[:notice] = 'PrizeAct was successfully created.' if @prize_act.save
    respond_with(@prize_act)
  end

  def update
    flash[:notice] = 'PrizeAct was successfully updated.' if @prize_act.update(prize_act_params)
    respond_with(@prize_act)
  end

  def destroy
    @prize_act.destroy
    respond_with(@prize_act)
  end

  private
    def set_prize_act
      @prize_act = PrizeAct.find(params[:id])
    end

    def prize_act_params
      params.require(:prize_act).permit(:name, :desc, :prize_type, :start_time, :end_time, :is_open, :join_num, :person_limit)
    end
end
