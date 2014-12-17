class WxMenusController < ApplicationController
  before_action :set_wx_menu, only: [:show, :edit, :update, :destroy]

  def index
    @wx_menus = WxMenu.all
    respond_with(@wx_menus)
  end

  def show
    respond_with(@wx_menu)
  end

  def new
    @wx_menu = WxMenu.new
    respond_with(@wx_menu)
  end

  def edit
  end

  def create
    @wx_menu = WxMenu.new(wx_menu_params)
    flash[:notice] = 'WxMenu was successfully created.' if @wx_menu.save
    respond_with(@wx_menu)
  end

  def update
    flash[:notice] = 'WxMenu was successfully updated.' if @wx_menu.update(wx_menu_params)
    respond_with(@wx_menu)
  end

  def destroy
    @wx_menu.destroy
    respond_with(@wx_menu)
  end

  private
    def set_wx_menu
      @wx_menu = WxMenu.find(params[:id])
    end

    def wx_menu_params
      params.require(:wx_menu).permit(:name, :msg, :url, :msg_or_url, :button_type, :key, :parent_id, :level)
    end
end
