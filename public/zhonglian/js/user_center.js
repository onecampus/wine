//用于显示商品的合计
$(document).ready(function() {
  //先判断有无商品交易记录
  if (!$('.top').next().size()) {
    $('.main').append('<div class="announcement"><p>暂无记录</p></div>');
  } else {
    //计算每个订单内的商品总价
    var $history_order = $('.history_order');
    var h_num = $history_order.size(); //订单总数
    for (var j = 0; j < h_num; j++) {
      var $ordered_product = $($history_order.get(j)).find('.ordered_product');
      var orderedN = $ordered_product.size();
      var $sum = $($history_order.get(j)).find('.sum');
      var $freight = $($history_order.get(j)).find('.freight');
      var freight = $freight.text();
      var freightN = parseFloat(freight.substr(freight.indexOf('￥') + 1).trim());
      var sum = 0.00;
      for (var k = 0; k < orderedN; k++) {
        var $o_p = $($ordered_product.get(k));
        var $price = $o_p.find('.order_price');
        var p_num = $price.size();
        var $num = $o_p.find('.order_num');
        for (var i = 0; i < p_num; i++) {
          var priceN = $price.get(i).innerHTML.trim().substr(0).trim();
          var numN = $num.get(i).innerHTML.trim().substr(1).trim();
          var times = (Number(parseFloat(priceN) * parseFloat(numN))).toFixed(2);
          times = parseFloat(times);
          sum = (Number(sum + times)).toFixed(2);
          sum = parseFloat(sum);
        }
      }
      sum = (Number(sum + freightN)).toFixed(2); //某订单内的总价
      $sum.text("合计：￥" + sum + "元");
    }
  }
});
