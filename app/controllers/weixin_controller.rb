# encoding: UTF-8
require 'json'
require 'net/http'
require 'open-uri'
require 'cgi'

class WeixinController < ApplicationController
  skip_before_filter :verify_authenticity_token

  skip_before_action :require_login, only: [:show, :create]

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

  private

  def http_get(domain, path, params)
    return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k, v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
    Net::HTTP.get(domain, path)
  end

  def render_text
    render 'text', formats: :xml
  end

  def render_text_which_start_with
    render 'text_which_start_with', formats: :xml
  end

  def render_image
    render 'image', formats: :xml
  end

  def render_voice
    render 'voice', formats: :xml
  end

  def render_video
    render 'video', formats: :xml
  end

  def render_music
    render 'music', formats: :xml
  end

  def render_image_and_text
    render 'image_and_text', formats: :xml
  end

  def check_weixin_legality
    array = ['rubywine', params[:timestamp], params[:nonce]].sort
    render text: 'Forbidden', status: 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
end
