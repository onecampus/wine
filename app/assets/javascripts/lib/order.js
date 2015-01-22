$(document).ready(function() {
  $(".form-box input").focus(function() {
    $(".address-mesg").hide();
  });

  $(".invoice-inf input").focus(function() {
    $(".invoice-mesg").hide();
  });

  $(".btn-add-address").click(function() {
    var uid = $("[name='uid']").val();
    receive_name = $(".receive_name").val(),
      province = $("#s1 option:selected").text(),
      city = $("#s2 option:selected").text(),
      region = $("#s3 option:selected").text(),
      address = $("[name='address']").val(),
      postcode = $("[name='postcode']").val(),
      tel = $("[name='tel']").val(),
      mobile = $("[name='mobile']").val();
    if (receive_name == "") {
      $(".address-mesg").children().text("用户名不能为空");
      $(".address-mesg").show();
      return;
    }
    if (address == "") {
      $(".address-mesg").children().text("地址不能为空");
      $(".address-mesg").show();
      return;
    }
    if (postcode == "") {
      $(".address-mesg").children().text("邮政编码不能为空");
      $(".address-mesg").show();
      return;
    }
    if (tel == "") {
      $(".address-mesg").children().text("手机不能为空");
      $(".address-mesg").show();
      return;
    }
    $(this).attr("disabled","disabled");
    $(".order-address").show();
    $(".invoice-need").show();
    var params = {
      "receive_name": receive_name,
      "province": province,
      "city": city,
      "region": region,
      "address": address,
      "postcode": postcode,
      "tel": tel,
      "mobile": mobile,
    };
    $.ajax({
      type: "POST",
      url: "/customer/shipaddresses/create/json",
      data: params,
      dataType: "json",
      success: function(data) {
        $(".address-id").val(data.data);
        $(".confirm-address").text(province + city + region + address);
        $(".form-box").fadeOut(100);
        $("hr").show();
        $(".order").show();
        $(".promo-code").show();
        $(".order-address").show();
        $(".invoice-need").show();
        $(".btn-add-address").attr("disabled",false);
      },
      error: function() {
        // code
      }
    });
  });

  $(".confirm-invoice").click(function() {
    var rise = $(".rise").val();
    var content = $(".content").val();
    if (rise == "") {
      $(".invoice-mesg").text("发票抬头不能为空");
      $(".invoice-mesg").show();
      return;
    }
    if (content == "") {
      $(".invoice-mesg").text("发票内容不能为空");
      $(".invoice-mesg").show();
      return;
    }
    $(this).attr("disabled","disabled");
    $.ajax({
      type: "POST",
      url: "/customer/invoice/create/json",
      data: {
        rise: rise,
        content: content
      },
      dataType: "json",
      success: function(data) {
        $(".invoice-id").val(data.data);
        $(".invoice-not").text("开发票");
        $(".invoice-not").css("color", "#aa0c40");
        $(".invoice-inf").fadeOut(100);
        $("hr").show();
        $(".invoice-hr").hide();
        $(".order").show();
        $(".promo-code").show();
        $(".order-address").show();
        $(".invoice-need").show();
        $(".confirm-invoice").attr("disabled",false);
      },
      error: function() {
        alert("errors")
      }
    });
  });
  // create_order params:
  // ship_address_id int
  // has_invoice_id 0/1 是否提供发票 invoice: {rise, content}
  // ship_method, payment_method
  // products: [{product_id, product_count}, {product_id, product_count}]
  $(".order-btn").click(function() {
    var address = $(".confirm-address").text();
    if (address == "") {
      $("#order-message p").text("地址不能为空!");
      $.blockUI({
        message: $('#order-message'),
        css: {
        border: 'none',
        padding: '15px',
        backgroundColor: '#000',
        '-webkit-border-radius': '10px',
        '-moz-border-radius': '10px',
        opacity: .5,
        color: '#fff'
        }
      });
      setTimeout($.unblockUI, 1500);
    }
    else {
      var addressId = $(".address-id").val();
      var shoppingCart = $.localStorage.get("shoppingCart");
      if (shoppingCart === null || shoppingCart === "") {
        return;
      }
      else {
        var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
        var orderType = JsonStr.order_type;
        var isProduct = null;
        var isGroup = null;
        var isSeckill = null;
        if (orderType == "is_product") {
          isProduct = 1;
          isGroup = 0;
          isSeckill = 0;
        }
        if (orderType == "is_group") {
          isProduct = 0;
          isGroup = 1;
          isSeckill = 0;
        }
        if (orderType == "is_seckill") {
          isProduct = 0;
          isGroup = 0;
          isSeckill = 1;
        }
        var productList = JsonStr.productList;
        var invoiceId = $(".invoice-id").val();
        var shareLinkCode = JsonStr.shareLinkCode;
        var inviteCode = $(".invite-code").val();
        var products = [];
        for (var i in productList) {
          if (productList[i].buyMark == true) {
            var id = productList[i].id;
            var num = parseInt(productList[i].num);
            var produckMark = productList[i].productMark;
            products.push({
              "product_id": id,
              "product_count": num,
            });
          }
        }
        $(this).attr("disabled","disabled");
        var data =null;
        if((invoiceId == 0) && (shareLinkCode == null) && (inviteCode == "")){
            data = {
              ship_address_id: addressId,
              ship_method: 'express',
              payment_method: 'weixinpayment',
              products: products,
              is_product: isProduct,
              is_group: isGroup,
              is_seckill: isSeckill
            };
        }
        else if((invoiceId == 0) && (shareLinkCode != null) && (inviteCode == "")){
            data = {
              ship_address_id: addressId,
              ship_method: 'express',
              payment_method: 'weixinpayment',
              products: products,
              share_link_code: shareLinkCode,
              is_product: isProduct,
              is_group: isGroup,
              is_seckill: isSeckill
            };
        }
        else if((invoiceId == 0) && (shareLinkCode == null) && (inviteCode != "")){
          data = {
            ship_address_id: addressId,
            ship_method: 'express',
            payment_method: 'weixinpayment',
            products: products,
            invite_code: inviteCode,
            is_product: isProduct,
            is_group: isGroup,
            is_seckill: isSeckill
          };
        }
        else if((invoiceId != 0) && (shareLinkCode == null) && (inviteCode == "")){
            data = {
              ship_address_id: addressId,
              invoice_id: invoiceId,
              ship_method: 'express',
              payment_method: 'weixinpayment',
              products: products,
              is_product: isProduct,
              is_group: isGroup,
              is_seckill: isSeckill
            };
        }
        else if((invoiceId != 0) && (shareLinkCode != null) && (inviteCode == "")){
          data = {
            ship_address_id: addressId,
            invoice_id: invoiceId,
            ship_method: 'express',
            payment_method: 'weixinpayment',
            products: products,
            share_link_code: shareLinkCode,
            is_product: isProduct,
            is_group: isGroup,
            is_seckill: isSeckill
          };
        }
        else if((invoiceId != 0) && (shareLinkCode == null) && (inviteCode != "")){
          data = {
            ship_address_id: addressId,
            invoice_id: invoiceId,
            ship_method: 'express',
            payment_method: 'weixinpayment',
            products: products,
            invite_code: inviteCode,
            is_product: isProduct,
            is_group: isGroup,
            is_seckill: isSeckill
          };
        }
        else if((invoiceId == 0) && (shareLinkCode != null) && (inviteCode != "")){
          data = {
            invoice_id: invoiceId,
            ship_method: 'express',
            payment_method: 'weixinpayment',
            products: products,
            share_link_code: shareLinkCode,
            invite_code: inviteCode,
            is_product: isProduct,
            is_group: isGroup,
            is_seckill: isSeckill
          };
        }
        else {
            data = {
              ship_address_id: addressId,
              invoice_id: invoiceId,
              ship_method: 'express',
              payment_method: 'weixinpayment',
              products: products,
              share_link_code: shareLinkCode,
              invite_code: inviteCode,
              is_product: isProduct,
              is_group: isGroup,
              is_seckill: isSeckill
            };
        }
        $.ajax({
          type: "POST",
          url: "/customer/orders/create",
          data: data,
          dataType: "json",
          success: function(data) {
            // code
            if(data.status == "error") {
              orderError();
              return false;
            }
            else{
              for (var i in productList) {
                if (productList[i].buyMark == true) {
                  var productId = productList[i].id;
                  deleteProduct(productId);
                }
              }
              $(".order-btn").attr("disabled",false);
              showShoppingCartItem();
              cleanShareLinkCode();
              orderSuccessHan();
            }
          },
          complete: function(XMLHttpRequest, textStatus) {
            // orderErrorHan(XMLHttpRequest, textStatus);
          },
          error: function(XMLHttpRequest, textStatus, errorThrown) {
            orderErrorHan(XMLHttpRequest, textStatus);
          }
        });
      }
    }
  });
});

function deleteProduct(id) {
  var shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
    return;
  }
  else {
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var productList = JsonStr.productList;
    var orderType = JsonStr.order_type;
    if(orderType == "is_product") {
      orderType = "product";
    }
    else if (orderType == "is_group") {
      orderType = "group";
    }
    else {
      orderType = "seckill";
    }
    var list = [];
    for (var i in productList) {
      if (productList[i].id == id && productList[i].productType == orderType) {
        JsonStr.totalNumber = parseInt(JsonStr.totalNumber) - parseInt(productList[i].num);
        JsonStr.totalAmount = parseFloat(JsonStr.totalAmount) - parseInt(productList[i].num) * parseFloat(productList[i].price);
      } else {
        list.push(productList[i]);
      }
    }
    JsonStr.productList = list;
    $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
  }
}

function orderSuccessHan() {
  alert("您的商品购买成功！");
  location.href="/customer/users/wait/ship";
}

function orderErrorHan(XMLHttpRequest, textStatus) {
  if(XMLHttpRequest.status == 422 && textStatus == 'error') {
    $("#order-message p").text("订单创建失败, 您是供应商, 不能自己创建订单");
    $.blockUI({
      message: $('#order-message'),
      css: {
        border: 'none',
        padding: '15px',
        backgroundColor: '#000',
        '-webkit-border-radius': '10px',
        '-moz-border-radius': '10px',
        opacity: .5,
        color: '#fff'
      }
    });
    setTimeout($.unblockUI, 2500);
  }
}

function orderError(){
  $("#order-message p").text("订单创建失败!");
  $.blockUI({
    message: $('#order-message'),
    css: {
      border: 'none',
      padding: '15px',
      backgroundColor: '#000',
      '-webkit-border-radius': '10px',
      '-moz-border-radius': '10px',
      opacity: .5,
      color: '#fff'
    }
  });
  setTimeout($.unblockUI, 2500);
}


function showShoppingCartItem() {
  var shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
    $(".shopping-cart-mark").hide();
  }
  else {
    console.log("shoppingCart is " + shoppingCart);
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var length = 0;
    var productList = JsonStr.productList;
    for (i in productList) {
      if(productList[i].productType == "product") {
        length = length +1;
      }
    }
    if (length > 0) {
      $(".shopping-cart-mark").show();
      $(".shopping-cart-mark").text(length);
    }
    else {
      $(".shopping-cart-mark").hide();
    }
  }
}

function cleanShareLinkCode(){
  var shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
    return;
  }
  else {
    var JsonStr = JSON.parse(shoppingCart.substr(1,shoppingCart.length));
    JsonStr.shareLinkCode = null;
    $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
  }
}
