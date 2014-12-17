# encoding: UTF-8
require 'json'
require 'rest_client'

class WeixinController < ApplicationController
  skip_before_filter :verify_authenticity_token

  skip_before_filter :authenticate_user!, only: [:show, :create]

  before_filter :check_weixin_legality

  def show
    render text: params[:echostr]
  end

  def create
    query_type = params[:xml][:MsgType]
    if query_type == 'event'
      if params[:xml][:Event] == 'subscribe'
        @reply_text = '感谢你对我们的支持,输入 帮助 或者 help 或者 ? 获取帮助信息.'
        render_text
      elsif params[:xml][:Event] == 'unsubscribe'
        @reply_text = '感谢您一直以来对我们的支持.'
        render_text
      end
    elsif query_type == 'text'
      query = params[:xml][:Content]
      if query == '帮助' || query == 'help' || query == '?' || query == '？'
        @reply_text = '点击微信菜单进行您的活动吧.'
        render_text
      elsif query[0...1].to_i.to_s == query[0...1]
        @reply_text = '感谢你对我们的支持,输入 帮助 或者 help 或者 ? 获取帮助信息.'
        render_text
      end
    end
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

    url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{access_token}"
    res = RestClient.post url, menus.to_json, content_type: :json, accept: :json
    res_hash = JSON.parse res
    if res_hash[:errcode] == 0 && res_hash[:errmsg] == 'ok'
      render json: { status: 'success', msg: 'create menu success' }
    else
      render json: { status: 'error', msg: 'create menu failed' }
    end
  end

  private

  def render_text
    render 'text', formats: :xml
  end

  def check_weixin_legality
    array = ['rubywine', params[:timestamp], params[:nonce]].sort
    render text: 'Forbidden', status: 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  def get_access_token(appid = 'wxa2bbd3b7a22039df', grant_type = 'client_credential', secret = '724bbaea1bce4c09865c2c47acbf450d')
    url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=#{grant_type}&appid=#{appid}&secret=#{secret}"
    res = RestClient.get url, {accept: :json}
    JSON.parse res
  end

  def get_oauth_code
    url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxa2bbd3b7a22039df&redirect_uri=http://203.195.172.200&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect"
    RestClient.get url
  end

  def get_oauth_access_token(code, appid = 'wxa2bbd3b7a22039df', secret = '724bbaea1bce4c09865c2c47acbf450d')
    url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{appid}&secret=#{secret}&code=#{code}&grant_type=authorization_code"
    res = RestClient.get url, {accept: :json}
    JSON.parse res
  end

  def refresh_oauth_access_token(appid = 'wxa2bbd3b7a22039df', refresh_token)
    url = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=#{appid}&grant_type=refresh_token&refresh_token=#{refresh_token}"
    res = RestClient.get url, {accept: :json}
    JSON.parse res
  end

  def get_user_info(openid, access_token)
    url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
    res = RestClient.get url, {accept: :json}
    JSON.parse res
  end
end
