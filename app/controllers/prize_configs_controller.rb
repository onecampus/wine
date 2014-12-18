class PrizeConfigsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_prize_config, only: [:show, :edit, :update, :destroy]

  def index
    @prize_configs = PrizeConfig.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@prize_configs)
  end

  def show
    respond_with(@prize_config)
  end

  def new
    @prize_config = PrizeConfig.new
    @prize_acts = PrizeAct.where(prize_type: 'bigwheel', is_open: 1)
    @act_arr = []
    @prize_acts.each do |pa|
      @act_arr.push [pa.name, pa.id]
    end
    respond_with(@prize_config)
  end

  def edit
    @prize_acts = PrizeAct.where(prize_type: 'bigwheel', is_open: 1)
    @act_arr = []
    @prize_acts.each do |pa|
      @act_arr.push [pa.name, pa.id]
    end
  end

  def create
    @prize_config = PrizeConfig.new(prize_config_params)
    flash[:notice] = 'PrizeConfig was successfully created.' if @prize_config.save
    respond_with(@prize_config)
  end

  def update
    flash[:notice] = 'PrizeConfig was successfully updated.' if @prize_config.update(prize_config_params)
    respond_with(@prize_config)
  end

  def destroy
    @prize_config.destroy
    respond_with(@prize_config)
  end

  private

  def set_prize_config
    @prize_config = PrizeConfig.find(params[:id])
  end

  def prize_config_params
    params.require(:prize_config).permit(:prize_act_id, :prize_name, :min, :max, :prize_content, :prize_inventory, :chance)
  end
end
