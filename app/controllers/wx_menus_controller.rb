# encoding: UTF-8
require 'json'
require 'rest_client'

class WxMenusController < ApplicationController
  authorize_resource
  respond_to :html, :json
  before_action :set_wx_menu, only: [:set_menu_action]

  skip_before_filter :verify_authenticity_token, only: [:update_via_json,
                                                        :create_via_ajax,
                                                        :destroy_via_ajax,
                                                        :create_menu_name,
                                                        :set_menu_action,
                                                        :upload_img]

  def index
    @wx_menus = WxMenu.where(level: 1).last 3
  end

  def create_menu_name
    wx_menu_params = {
      name: params[:name],
      parent_id: params[:parent_id], # 第一级菜单 0
      level: params[:level] # 第一级菜单 1
    }
    @wx_menu = WxMenu.new(wx_menu_params)
    if @wx_menu.save
      # 如果添加二级菜单,需要清空一级菜单的事件
      if params[:level].to_i != 1 && params[:parent_id].to_i != 0
        parent_menu = WxMenu.find(params[:parent_id]) if params[:parent_id].to_i != 0
        parent_menu.button_type = nil
        parent_menu.msg_or_url = nil
        parent_menu.msg_type = nil
        parent_menu.save
      end
      render json: { status: 'success', msg: 'create menu success' }
    else
      render json: { status: 'error', msg: 'create menu failed' }
    end
  end

  def set_menu_action
    button_type = params[:button_type]
    @wx_menu.button_type = button_type  # click(key), view(url)
    case button_type
    when 'click'
      msg_type = params[:msg_type]  # text, image, news
      @wx_menu.msg_or_url = 'msg'
      @wx_menu.key = WxMenu.generate_key
      @wx_menu.msg_type = msg_type
      case msg_type
      when 'text'
        @wx_menu.description = params[:content]
      when 'image'
        @wx_menu.media_id = params[:media_id]
      when 'news'
        @wx_menu.title = params[:title]
        @wx_menu.description = params[:description]
        @wx_menu.img = params[:img]
        @wx_menu.url = params[:url]
      end
    when 'view'
      @wx_menu.msg_or_url = 'url'
      @wx_menu.url = params[:url]
    end
    if @wx_menu.save
      render json: { status: 'success', msg: 'set_menu_action success' }
    else
      render json: { status: 'failed', msg: 'set_menu_action failed' }
    end
  end

  def upload_img
    image = WeixinUploaderUploader.new
    image.store!(params[:img])
    return_hash = {
      status: 'success',
      url: image.url,
      title: image.filename
    }
    msg_type = params[:msg_type]  # image, news
    if msg_type == 'image'
      file = image.retrieve_from_store!(image.filename)
      res_hash = WxExt::Api::Base.upload_media(set_access_token, 'image', file)
      # {"type":"TYPE","media_id":"MEDIA_ID","created_at":123456789}
      if res_hash['media_id'].blank?
        return_hash[:status] = 'weixin_failed'
      else
        return_hash[:media_id] = res_hash['media_id']
      end
    end
    render json: return_hash
  end

  def update_via_json
    mu = WxMenu.find params[:pk]
    mu.name = params[:value] if params[:name] == 'name'
    mu.url = params[:value] if params[:name] == 'url'
    if mu.save
      render json: { status: 'success', msg: 'update success' }
    else
      render json: { status: 'error', msg: 'update failed' }
    end
  end

  def create_weixin_menu
    res_hash = create_custom_menu(set_access_token)
    puts '-' * 20
    puts res_hash
    if res_hash['errcode'] == 0 && res_hash['errmsg'] == 'ok'
      render json: { status: 'success', msg: 'create menu success' }
    else
      render json: { status: 'error', msg: 'create menu failed' }
    end
  end

  def create_via_ajax
    wx_menu_params = {
      name: params[:name],
      msg: '',
      url: params[:url],
      msg_or_url: 1,
      button_type: 'view',
      key: '',
      parent_id: params[:parent_id],
      level: params[:level]
    }
    @wx_menu = WxMenu.new(wx_menu_params)
    if @wx_menu.save
      render json: { status: 'success', msg: 'create menu success' }
    else
      render json: { status: 'error', msg: 'create menu failed' }
    end
  end

  def destroy_via_ajax
    @wx_menu = WxMenu.find(params[:id])
    sub_menus = WxMenu.where(level: 2, parent_id: @wx_menu.id)
    if @wx_menu.destroy
      sub_menus.each(&:destroy!) unless sub_menus.blank?
      render json: { status: 'success', msg: 'del menu success' }
    else
      render json: { status: 'error', msg: 'del menu failed' }
    end
  end

  private

  def set_wx_menu
    @wx_menu = WxMenu.find(params[:id])
  end

  def set_access_token
    app_id = ENV['APP_ID']
    app_secret = ENV['APP_SECRET']
    access_token_hash = WxExt::Api::Base.get_access_token(app_id, app_secret, 'client_credential')
    access_token_hash[:access_token]
  end

  def create_custom_menu(access_token)
    menus = { button: [] }
    top_mus = WxMenu.where(level: 1).last 3
    top_mus.each do |tm|
      tmp_hash = {
        name: tm.name,
        sub_button: []
      }
      WxMenu.where(level: 2, parent_id: tm.id).last(5).each do |sm|
        tmp_hash[:sub_button].push(
          type: 'view',
          name: sm.name,
          url: sm.url
        )
      end
      menus[:button].push tmp_hash
    end

    json = menus.to_json.gsub!(/\\u([0-9a-z]{4})/) { |s| [$1.to_i(16)].pack('U') }

    json = menus.to_json if json.blank?

    url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{access_token}"
    res = RestClient.post url, json
    JSON.parse res
  end
end
