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
    @prize_act.join_num = 0
    flash[:notice] = '抽奖活动创建成功, 下一步设置奖品'
    if @prize_act.save
      prize_config1 = PrizeConfig.new(
        prize_act_id: @prize_act.id,
        prize_name: '一等奖',
        min: '1',
        max: '29',
        prize_content: 'iphone 6',
        prize_inventory: 1,
        chance: 1
      )
      prize_config1.save!

      prize_config2 = PrizeConfig.new(
        prize_act_id: @prize_act.id,
        prize_name: '二等奖',
        min: '302',
        max: '328',
        prize_content: 'iphone 5',
        prize_inventory: 2,
        chance: 2
      )
      prize_config2.save!

      prize_config3 = PrizeConfig.new(
        prize_act_id: @prize_act.id,
        prize_name: '三等奖',
        min: '242',
        max: '268',
        prize_content: '现金500',
        prize_inventory: 3,
        chance: 5
      )
      prize_config3.save!

      prize_config4 = PrizeConfig.new(
        prize_act_id: @prize_act.id,
        prize_name: '四等奖',
        min: '182',
        max: '208',
        prize_content: '现金300',
        prize_inventory: 8,
        chance: 7
      )
      prize_config4.save!

      prize_config5 = PrizeConfig.new(
        prize_act_id: @prize_act.id,
        prize_name: '五等奖',
        min: '122',
        max: '148',
        prize_content: '现金200',
        prize_inventory: 20,
        chance: 10
      )
      prize_config5.save!

      prize_config6 = PrizeConfig.new(
        prize_act_id: @prize_act.id,
        prize_name: '六等奖',
        min: '62',
        max: '88',
        prize_content: '现金100',
        prize_inventory: 50,
        chance: 25
      )
      prize_config6.save!

      prize_config7 = PrizeConfig.new(
        prize_act_id: @prize_act.id,
        prize_name: '七等奖',
        min: '32,92,152,212,272,332',
        max: '58,118,178,238,298,358',
        prize_content: '谢谢惠顾',
        prize_inventory: 10_000_000,
        chance: 9950
      )
      prize_config7.save!
    end
    respond_with(@prize_act)
  end

  def update
    flash[:notice] = '抽奖活动更新成功' if @prize_act.update(prize_act_params)
    respond_with(@prize_act)
  end

  def destroy
    @prize_act.destroy
    @prize_act.prize_configs.each do |pc|
      PrizeUser.where(prize_config_id: pc.id).each do |pu|
        pu.destroy
      end
      pc.destroy
    end
    PrizeUserNumber.where(prize_act_id: @prize_act.id).each do |pun|
      pun.destroy
    end
    respond_with(@prize_act)
  end

  private

  def set_prize_act
    @prize_act = PrizeAct.find(params[:id])
  end

  def prize_act_params
    params.require(:prize_act).permit(:name, :desc, :prize_type, :start_time, :end_time, :is_open, :person_limit)
  end
end
