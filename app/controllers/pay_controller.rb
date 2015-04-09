require 'digest/md5'
require 'securerandom'
##
# This class is a controller for customer from weixin brower.
class PayController < CustomerController
  layout 'customer'

  skip_before_filter :authenticate_user!, only: [:notify]
  skip_before_filter :verify_authenticity_token, only: [:notify]

  def pay
    # 获取openid
    code = params[:code]
    order_number = params[:state]
    app_secret = ENV['APP_SECRET']
    app_id = ENV['APP_ID']
    auth_token_hash = WxExt::Api::User.get_oauth2_token_with_code(app_id, app_secret, code)
    openid = auth_token_hash['openid']

    # 用户ip
    ip = request.remote_ip

    # 查找订单
    order_native = Order.where(order_number: order_number).first
    price = (order_native.total_price.to_f * 100).to_i

    # 保存用户openid
    order_native.weixin_open_id = openid
    order_native.save!

    # 下单到微信, 返回 prepay_id
    params_pre_pay = {
      body: order_number,
      out_trade_no: order_number,  # 商户订单号
      total_fee: price,  # 总金额, 单位为分
      spbill_create_ip: ip,  # 终端IP
      notify_url: ENV['NOTIFY_URL'],
      trade_type: 'JSAPI',  # could be "JSAPI" or "NATIVE",
      openid: openid  # required when trade_type is `JSAPI`
    }

    Rails.logger.info "-----------params_pre_pay is  #{params_pre_pay}----------"

    r_hash = WxPay::Service.invoke_unifiedorder params_pre_pay

    Rails.logger.info "===========r_hash is  #{r_hash}========="

    if r_hash[:r].success?
      @js_noncestr = SecureRandom.uuid.tr('-', '')
      @js_timestamp = Time.now.getutc.to_i.to_s
      @app_id = ENV['APP_ID']
      @package = "prepay_id=#{r_hash[:r]['prepay_id']}"

      params_pre_pay_js = {
        appId: @app_id,
        nonceStr: @js_noncestr,
        package: @package,
        timeStamp: @js_timestamp,
        signType: 'MD5'
      }
      @js_pay_sign = WxPay::Sign.generate(params_pre_pay_js)
      flash.now[:alert] = '下单成功'
    else
      flash.now[:alert] = '下单失败'
    end
  end

  def pay_success
    # 支付成功
  end

  # 异步通知结果
  def notify
    result = Hash.from_xml(request.body.read)["xml"]

    if WxPay::Sign.verify?(result)

      # 支付成功，处理订单罗辑
      order_number = result[:out_trade_no]
      # 查找订单
      # order_status: {1: 未处理, 2: 已确定, 3: 已完成, 4: 已取消}
      # pay_status: {1: 未付款, 2: 已付款}
      # logistics_status: {0: 订单还未处理, 1: 备货中, 2: 已发货, 3: 已收货, 4: 已退货}
      order_native = Order.where(order_number: order_number).first
      order_native.payment_method = 'weixinpayment'
      order_native.pay_status = 2
      order_native.save!

      render :xml => {return_code: 'SUCCESS'}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: 'SUCCESS', return_msg: '签名失败'}.to_xml(root: 'xml', dasherize: false)
    end
  end

end
