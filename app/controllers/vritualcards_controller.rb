class VritualcardsController < ApplicationController
  authorize_resource
  respond_to :html, :json
  
  before_action :set_vritualcard, only: [:show, :edit, :update, :destroy]

  def index
    @vritualcards = Vritualcard.all.paginate(:page => params[:page], :per_page => 10).order('id DESC')
    respond_with(@vritualcards)
  end

  def show
    respond_with(@vritualcard)
  end

  def new
    @vritualcard = Vritualcard.new
    respond_with(@vritualcard)
  end

  def edit
  end

  def create
    @vritualcard = Vritualcard.new(vritualcard_params)
    flash[:notice] = 'Vritualcard was successfully created.' if @vritualcard.save
    respond_with(@vritualcard)
  end

  def update
    flash[:notice] = 'Vritualcard was successfully updated.' if @vritualcard.update(vritualcard_params)
    respond_with(@vritualcard)
  end

  def destroy
    @vritualcard.destroy
    respond_with(@vritualcard)
  end

  private
    def set_vritualcard
      @vritualcard = Vritualcard.find(params[:id])
    end

    def vritualcard_params
      params.require(:vritualcard).permit(:user_id, :money)
    end
end
