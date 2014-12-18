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
        $(".form-box").fadeOut(1000);
        $("hr").show();
        $(".order").show();
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
        $(".invoice-not").css("color", "#aa0c40")
        $(".invoice-inf").fadeOut(100);
        $("hr").show();
        $(".order").show();
        $(".order-address").show();
        $(".invoice-need").show();
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
      alert("地址不能为空");
    } else {
      var addressId = $(".address-id").val();
      var shoppingCart = $.localStorage.get("shoppingCart");
      var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
      var productList = JsonStr.productList;
      var invoiceId = $(".invoice-id").val();
      var products = [];
      for (var i in productList) {
        if (productList[i].buyMark == true) {
          var id = productList[i].id;
          var num = parseInt(productList[i].num);
          var price = productList[i].price;
          price = price.substr(2, price.length);
          price = parseFloat(price);
          var subtotal = (Number(num * price)).toFixed(2);
          products.push({
            "product_id": id,
            "product_count": subtotal
          });
        }
      }
      $.ajax({
        type: "POST",
        url: "/customer/orders/create",
        data: {
          ship_address_id: addressId,
          invoice_id: invoiceId,
          ship_method: 'express',
          payment_method: 'weixinpayment',
          products: products
        },
        dataType: "json",
        success: function(data) {
          // code

          for (var i in productList) {
            var productId = productList[i].id;
            deleteProduct(productId);
          }
          alert("success");
        },
        complete: function(XMLHttpRequest, textStatus) {
          // code
        },
        error: function() {
          // code
        }
      });
    }
  });
});

function deleteProduct(id) {
  var shoppingCart = $.localStorage.get("shoppingCart");
  var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
  var productList = JsonStr.productList;
  var list = [];
  for (var i in productList) {
    if (productList[i].id == id) {
      JsonStr.totalNumber = parseInt(JsonStr.totalNumber) - parseInt(productList[i].num);
      JsonStr.totalAmount = parseFloat(JsonStr.totalAmount) - parseInt(productList[i].num) * parseFloat(productList[i].price);
    } else {
      list.push(productList[i]);
    }
  }
  JsonStr.productList = list;
  $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
}
