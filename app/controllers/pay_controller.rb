##
# This class is a controller for customer from weixin brower.
class PayController < CustomerController
  layout 'customer'

  def pay
    # 支付页面
    # 保存订单

    # 下单到微信, 返回 prepay_id
    # required fields
    params = {
        body: '测试商品',
        out_trade_no: 'test003',
        total_fee: 1,
        spbill_create_ip: '127.0.0.1',
        notify_url: 'http://making.dev/notify',
        trade_type: 'JSAPI', # could be "JSAPI" or "NATIVE",
        openid: 'OPENID' # required when trade_type is `JSAPI`
    }

    r = WxPay::Service.invoke_unifiedorder params
    # => {
    #      "return_code"=>"SUCCESS",
    #      "return_msg"=>"OK",
    #      "appid"=>"YOUR APPID",
    #      "mch_id"=>"YOUR MCH_ID",
    #      "nonce_str"=>"8RN7YfTZ3OUgWX5e",
    #      "sign"=>"623AE90C9679729DDD7407DC7A1151B2",
    #      "result_code"=>"SUCCESS",
    #      "prepay_id"=>"wx2014111104255143b7605afb0314593866",
    #      "trade_type"=>"JSAPI"
    #    }
    # 生成 jsapi 参数

    # 跳转到支付页面
  end

  def pay_success
    # 支付成功
  end

  def product
    # 订单页面
  end

  # 异步通知结果
  def notify
    result = Hash.from_xml(request.body.read)["xml"]

    if WxPay::Sign.verify?(result)

      # find your order and process the post-paid logic.

      render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
    else
      render :xml => {return_code: "SUCCESS", return_msg: "签名失败"}.to_xml(root: 'xml', dasherize: false)
    end
  end

end