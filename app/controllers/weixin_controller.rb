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
        @reply_text = 'welcome'
        render_text
      elsif query[0...1].to_i.to_s == query[0...1]
        @reply_text = 'welcome to china'
        render_text
      end
    end
  end

  def create_custom_menu(access_token)
    menus = {
      button: [
        {
          name: '我的微网',
          sub_button: [
            {
              type: 'view',
              name: '会员',
              url: 'http://203.195.172.200'
            },
            {
              type: 'view',
              name: '天天有喜',
              url: 'http://203.195.172.200'
            },
            {
              type: 'view',
              name: '官网',
              url: 'http://203.195.172.200'
            }
          ]
        },
        {
          name: '优生活',
          sub_button: [
            {
              type: 'view',
              name: '优社区',
              url: 'http://203.195.172.200'
            },
            {
              type: 'view',
              name: '一起嗨皮',
              url: 'http://203.195.172.200'
            }
          ]
        },
        {
          name: '微商城',
          sub_button: [
            {
              type: 'view',
              name: '进口酒类',
              url: 'http://203.195.172.200'
            },
            {
              type: 'view',
              name: '其他进口酒类',
              url: 'http://203.195.172.200'
            },
            {
              type: 'view',
              name: '舌尖上的特产',
              url: 'http://203.195.172.200'
            },
            {
              type: 'view',
              name: '最强推荐',
              url: 'http://203.195.172.200'
            },
            {
              type: 'view',
              name: '订单查询',
              url: 'http://203.195.172.200'
            }
          ]
        }
      ]
    }
    url = "https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{access_token}"
    res = RestClient.post url, menus.to_json, content_type: :json, accept: :json
    JSON.parse res
  end

  def get_oauth_code
    url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxa2bbd3b7a22039df&redirect_uri=http://203.195.172.200&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect"
    RestClient.get url
  end

  def get_oauth_access_token(code, appid = 'wxa2bbd3b7a22039df', secret)
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

  private

  def render_text
    render 'text', formats: :xml
  end

  def check_weixin_legality
    array = ['rubywine', params[:timestamp], params[:nonce]].sort
    render text: 'Forbidden', status: 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  def get_access_token(appid = 'wxa2bbd3b7a22039df', grant_type = 'client_credential', secret)
    url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=#{grant_type}&appid=#{appid}&secret=#{secret}"
    res = RestClient.get url, {accept: :json}
    JSON.parse res
  end
end
