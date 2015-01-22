# encoding: UTF-8

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
      elsif params[:xml][:Event] == 'CLICK'
        key = params[:xml][:EventKey]
        wx_menu = WxMenu.where(key: key, button_type: 'click', msg_or_url: 'msg').last
        if wx_menu.blank?
          @reply_text = '工程师正在加紧赶工, 敬请期待.'
          render_text
        else
          msg_type = wx_menu.msg_type
          case msg_type
          when 'text'
            @reply_text = wx_menu.description
            render_text
          when 'image'
            @reply_img_id = wx_menu.media_id
            render_image
          when 'news'
            @wx_menu = wx_menu
            render_news
          else
            @reply_text = '工程师正在加紧赶工, 敬请期待.'
            render_text
          end
        end
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
    # elsif query_type == 'image'
    # elsif query_type == 'news'
    end
  end

  private

  def render_text
    render 'text', formats: :xml
  end

  def render_image
    render 'image', formats: :xml
  end

  def render_news
    render 'news', formats: :xml
  end

  def check_weixin_legality
    array = ['rubywine', params[:timestamp], params[:nonce]].sort
    render text: 'Forbidden', status: 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end
