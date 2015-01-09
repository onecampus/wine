$(document).ready(function(){
  var Utils = {
    setParam: function(name, value) {
      $.localStorage.set(name, value);
    },
    getParam: function(name) {
      return $.localStorage.get(name);
    },
    getJSONProductList: function() {
      var shoppingCart = Utils.getParam("shoppingCart");
      var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
      return JsonStr.productList;
    }
  };
  var OrderDetail = {
    username: "",
    phone: "",
    address: "",
    zipcode: "",
    totalNumber: 0,
    totalAmount: 0.00,
    shareLinkCode: null,
    inviteCode: null,
    order_type: "is_product"
  };
  var Cart = {
    buyProduct: function(product) {
      var shoppingCart = Utils.getParam("shoppingCart"),
      JsonStr = Object;
      if (shoppingCart === null || shoppingCart === "") {
        //第一次加入商品
        JsonStr = {
          "productList": [{
            "id": product.id,
            "name": product.name,
            "englishname": product.englishname,
            "num": product.num,
            "price": product.price,
            "img": product.img,
            "buyMark": product.buyMark,
            "freight": product.freight
          }],
          "totalNumber": product.num,
          "totalAmount": (product.price * product.num),
          "shareLinkCode": null,
          "inviteCode": null,
          "order_type": "is_seckill",
        };
        Utils.setParam("shoppingCart", "'" + JSON.stringify(JsonStr));
      } else {
        JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
        var productList = JsonStr.productList;
        var result = false;
        //查找购物车中是否有该商品
        for (var i in productList) {
          if (productList[i].id == product.id) {
            productList[i].num = parseInt(productList[i].num) + parseInt(product.num);
            productList[i].buyMark = true;
            productList[i].num = product.num;
            productList[i].price = product.price;
            result = true;
          }
          else {
            productList[i].buyMark = false;
          }
        }
        if (!result) {
          //没有该商品就直接加进去
          productList.push({
            "id": product.id,
            "name": product.name,
            "englishname": product.englishname,
            "num": product.num,
            "price": product.price,
            "img": product.img,
            "buyMark": product.buyMark,
            "freight": product.freight
          });
        }
        //重新计算总价
        JsonStr.totalNumber = parseInt(JsonStr.totalNumber) + parseInt(product.num);
        JsonStr.totalAmount = parseFloat(JsonStr.totalAmount) + (parseInt(product.num) * parseFloat(product.price));
        JsonStr.order_type = "is_seckill";
        OrderDetail.totalNumber = JsonStr.totalNumber;
        OrderDetail.totalAmount = JsonStr.totalAmount;
        OrderDetail.order_type = JsonStr.order_type;
        //保存购物车
        Utils.setParam("shoppingCart", "'" + JSON.stringify(JsonStr));
      }
      var shoppingCart = $.localStorage.get("shoppingCart");
      if (shoppingCart === null || shoppingCart === "") {
        return;
      }
      else {
        var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
        productList = JsonStr.productList;
        var total = 0.00;
        for (var i in productList) {
          if (productList[i].id == product.id) {
            var num = productList[i].num;
            num = parseInt(num);
            var price = productList[i].price;
            price = price.substr(1,price.length);
            price = parseFloat(price);
            var freight = productList[i].freight;
            freight = parseFloat(freight);
            var product = (Number(price*num)).toFixed(2);
            product = parseFloat(product);

            total = (Number(product + freight)).toFixed(2);
            total = parseFloat(total);
          }
        }
        JsonStr.totalAmount = total;
        OrderDetail.totalAmount = JsonStr.totalAmount;
        $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
      }
    }
  };

  /*
  团购购买
  */
  $(".seckill-buy-now").click(function(){
    var name = $(".product-name").text(),
    englishname = $(".product-englishname").text(),
    price = $(".seckill-price").text(),
    num = $(".p-num").val(),
    id = $(".product-id").val(),
    img = $(".top-img").children().attr("src"),
    buyMark = true,
    freight = $(".freight-price").text();
    var product = {
      'id': id,
      'name': name,
      'englishname': englishname,
      'num': num,
      'price': price,
      'img': img,
      'buyMark': buyMark,
      'freight': freight
    };
    Cart.buyProduct(product);
    window.location = '/customer/orders/settlement';
  });
  /*秒杀时间倒数
  */
  GetRTime();
  //定义方法
  var timer_rt = window.setInterval("GetRTime()", 1000);
  //定义参数 显示出GetRTime()方法 1000毫秒以后启动
});

  function GetRTime(){
    var time = $(".seckill-endtime").val();
    time = time.toString();
    var year = time.substr(0,4);
    var month = time.substr(5);
    month = month.substr(0,2);
    month = parseInt(month) - 1;
    var day = time.substr(8);
    day = day.substr(0,2);
    var hour = time.substr(11);
    hour = hour.substr(0,2);
    var minute = time.substr(14);
    minute = minute.substr(0,2);
    var second = time.substr(17);
    second = second.substr(0,2);
    var startTime = new Date();
    //定义参数可返回当天的日期和时间
    startTime.setFullYear(year, month, day);
    //调用设置年份
    startTime.setHours(hour);
    //调用设置指定的时间的小时字段
    startTime.setMinutes(minute);
    //调用设置指定时间的分钟字段
    startTime.setSeconds(second);
    //调用设置指定时间的秒钟字段
    startTime.setMilliseconds(000);
    //调用置指定时间的毫秒字段
    var EndTime=startTime.getTime();
    //定义参数可返回距 1970 年 1 月 1 日之间的毫秒数

    //定义方法
    var NowTime = new Date();
    //定义参数可返回当天的日期和时间
    var nMS = EndTime - NowTime.getTime();
    //定义参数 EndTime减去NowTime参数获得返回距 1970 年 1 月 1 日之间的毫秒数
    var nD = Math.floor(nMS/(1000 * 60 * 60 * 24));
    //定义参数 获得天数
    var nH = Math.floor(nMS/(1000*60*60)) % 24;
    //定义参数 获得小时
    var nM = Math.floor(nMS/(1000*60)) % 60;
    //定义参数 获得分钟
    var nS = Math.floor(nMS/1000) % 60;
    //定义参数 获得秒钟
    if (nMS < 0){
      //如果秒钟大于0
      $(".time-inf").hide();
      //获得天数隐藏
      //获得活动截止时间展开
      $(".seckill-msg").show();
      $(".seckill-buy-now").attr("disabled","disabled");
    }else{
      //否则
      $(".seckill-buy-now").attr("disabled",false);
      $(".time-inf").show();
      //天数展开
      $("#daoend").hide();
      //活动截止时间隐藏
      $(".remainD").text(nD);
      //显示天数
      $(".remainH").text(nH);
      //显示小时
      $(".remainM").text(nM);
      //显示分钟
      $(".remainS").text(nS);
      //显示秒钟
    }
  }
