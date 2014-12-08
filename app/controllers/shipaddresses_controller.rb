class ShipaddressesController < ApplicationController

  authorize_resource
  respond_to :html, :json

  before_action :set_shipaddress, only: [:show, :edit, :update, :destroy]

  def index
    @shipaddresses = Shipaddress.all.paginate(page: params[:page],
                                              per_page: 10).order('id DESC')
    respond_with(@shipaddresses)
  end

  def show
    respond_with(@shipaddress)
  end

  def new
    @shipaddress = Shipaddress.new
    respond_with(@shipaddress)
  end

  def edit
  end

  def create
    @shipaddress = Shipaddress.new(shipaddress_params)
    flash[:notice] = 'Shipaddress was successfully created.' if @shipaddress.save
    respond_with(@shipaddress)
  end

  def update
    flash[:notice] = 'Shipaddress was successfully updated.' if @shipaddress.update(shipaddress_params)
    respond_with(@shipaddress)
  end

  def destroy
    @shipaddress.destroy
    respond_with(@shipaddress)
  end

  private
    def set_shipaddress
      @shipaddress = Shipaddress.find(params[:id])
    end

    def shipaddress_params
      params.require(:shipaddress).permit(:user_id, :receive_name, :province,
                                          :city, :region, :address,
                                          :postcode, :tel, :mobile)
    end
end
