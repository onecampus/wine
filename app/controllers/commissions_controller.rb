class CommissionsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_commission, only: [:show, :edit, :update, :destroy]

  def index
    if params[:commissiontype] == 'year'
      @commissions = Commission.where(commission_type: 'year').paginate(page: params[:page], per_page: 10).order('id DESC')
    else
      @commissions = Commission.all.paginate(page: params[:page], per_page: 10).order('id DESC')
    end
    respond_with(@commissions)
  end

=begin
  def year_compute_index
    @commissions = Commission.where(commission_type: 'year').paginate(page: params[:page], per_page: 10).order('id DESC')
    respond_with(@commissions)
  end

  def year_compute
    percent_a = SiteConfig.where(key: 'year_commission_a').first.val
    percent_b = SiteConfig.where(key: 'year_commission_b').first.val
    percent_c = SiteConfig.where(key: 'year_commission_c').first.val
    Score.all.each do |s|
      u = s.user
      p = u.profile
      p_p = p.parent
      if !p_p.blank?
        create_year_commisson(p.id, p_p.id, commission_money, percent_a, commission_score, money)
        p_p_p = p_p.parent
        if !p_p_p.blank?
          create_year_commisson(p_p.id, p_p_p.id, commission_money, percent_b, commission_score, money)
          p_p_p_p = p_p_p.parent
          if !p_p_p_p.blank?
            create_year_commisson(p_p_p.id, p_p_p_p.id, commission_money, percent_c, commission_score, money)
          end
        end
      end
    end
    flash[:notice] = '年度结算成功，请不要重复结算，每年一次.'
    redirect_to '/admin/commissions/year/index'
  end
=end

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

=begin
  def create_year_commisson(from_uid, uid, commission_money, percent, commission_score, money)
    Commission.transaction do
      Vritualcard.transaction do
        Commission.create!(
          from_user_id: from_uid,
          user_id: uid,
          order_id: 0,
          commission_money: commission_money,
          percent: percent,
          commission_type: 'year',
          commission_score: commission_score
        )

        Vritualcard.create!(
          user_id: uid,
          money: money
        )
      end
    end
  end
=end

    def set_commission
      @commission = Commission.find(params[:id])
    end

    def commission_params
      params.require(:commission).permit(:user_id, :order_id, :commission_money, :percent)
    end
end
