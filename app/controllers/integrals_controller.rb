class IntegralsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  
  before_action :set_integral, only: [:show, :edit, :update, :destroy]


  def index
    @integrals = Integral.all.paginate(:page => params[:page], :per_page => 10).order('id DESC')
    respond_with(@integrals)
  end

  def show
    respond_with(@integral)
  end

  def new
    @integral = Integral.new
    respond_with(@integral)
  end

  def edit
  end

  def create
    @integral = Integral.new(integral_params)
    flash[:notice] = 'Integral was successfully created.' if @integral.save
    respond_with(@integral)
  end

  def update
    flash[:notice] = 'Integral was successfully updated.' if @integral.update(integral_params)
    respond_with(@integral)
  end

  def destroy
    @integral.destroy
    respond_with(@integral)
  end

  private
    def set_integral
      @integral = Integral.find(params[:id])
    end

    def integral_params
      params.require(:integral).permit(:user_id, :amount)
    end
end
