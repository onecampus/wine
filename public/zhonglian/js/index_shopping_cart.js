$(document).ready(function() {
  var OrderDetail = {
    username: "",
    phone: "",
    address: "",
    zipcode: "",
    totalNumber: 0,
    totalAmount: 0.00
  };
  showProduct();
  total();
  $(".checkbox").click(function() {
    total();
  });
  /*全选
   */
  $(".allselect").click(function() {
    $(".checkbox").each(function() {
      this.checked = true;
    });
    total();
  });
  /*
  反选
  */
  $(".inselect").click(function() {
    $(".checkbox").each(function() {
      this.checked = !this.checked;
    });
    total();
  });
  /*
  number plus
  */
  $(".action-plus").click(function() {
    var num = parseInt($(this).siblings("p").text());
    num = num + 1;
    var subtotal = 0;
    var price = $(this).parent().siblings().attr("value");
    price = parseFloat(price);
    subtotal = (Number(num * price)).toFixed(2);
    $(this).parent().siblings().text("¥" + subtotal);
    $(this).siblings("p").text(num);
    total();
  });
  /*
  number dec
  */
  $(".action-de").click(function() {
    var num = parseInt($(this).siblings("p").text());
    if (num == 0) {
      return;
    } else {
      num = num - 1;
      var subtotal = 0;
      var price = $(this).parent().siblings().attr("value");
      price = parseFloat(price);
      subtotal = (Number(price * num)).toFixed(2);
      $(this).parent().siblings().text("¥" + subtotal);
      $(this).siblings("p").text(num);
      total();
    }
  });
/*
结算
*/
  $(".account").click(function() {
    $(".checkbox").each(function() {
      if (($(this).is(':checked')) == true) {
        var id = ($(this).parent().siblings("input").val());
        var num = $(this).parent().parent().children(".p-amount").children(".ampunt-action").children(".number").text();
        updateBuyMark(id, num, true);
      }
      if (($(this).is(':checked')) == false) {
        var id = ($(this).parent().siblings("input").val());
        var num = $(this).parent().parent().children(".p-amount").children(".ampunt-action").children(".number").text();
        updateBuyMark(id, num, false);
      }
    });
    var total = $(".total").text();
    var shoppingCart = $.localStorage.get("shoppingCart");
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    JsonStr.totalAmount = total;
    OrderDetail.totalAmount = JsonStr.totalAmount;
    $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
    var length = JsonStr.productList.length;
    if(length == 0) {
      return;
    }
    else{
      $(this).attr("href", "/customer/orders/settlement");
    }
  });
  /*
  清空购物车
  */
  $(".cleancart").click(function(){
    var shoppingCart = $.localStorage.get("shoppingCart");
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var shareLinkCode = JsonStr.shareLinkCode;
    alert(shareLinkCode);
    var productList = JsonStr.productList;
    var list = [];
    for (var i in productList) {
      JsonStr.totalNumber = parseInt(JsonStr.totalNumber) - parseInt(productList[i].num);
      JsonStr.totalAmount = parseFloat(JsonStr.totalAmount) - parseInt(productList[i].num) * parseFloat(productList[i].price);
    }
    JsonStr.productList = list;
    $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
    $(".freight").text(0);
    $(".total").text(0);
    showProduct();
  });

});
/*
合计
*/
function total() {
  var total = 0.00,
      productTotal = 0.00,
      totalFreight = 0.00,
      shoppingCart = $.localStorage.get("shoppingCart"),
      JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length)),
      productList = JsonStr.productList;
  $(".checkbox").each(function() {
    if (($(this).is(':checked')) == true) {
      productTotal = parseFloat(productTotal);
      totalFreight = parseFloat(totalFreight);
      var subtotal = $(this).parent().siblings(".p-amount").children(".price").text();
      subtotal = parseFloat(subtotal.substring(1, subtotal.length));
      productTotal = (Number(productTotal + subtotal)).toFixed(2);

      var productId = $(this).parent().siblings("input").val();
      for (var i in productList) {
        if (productList[i].id == productId) {
          var freight = productList[i].freight;
              freight = parseFloat(freight);
              totalFreight = (Number(totalFreight + freight)).toFixed(2);
        }
      }
    }
    productTotal = parseFloat(productTotal);
    totalFreight = parseFloat(totalFreight);
    total = (Number(totalFreight + productTotal)).toFixed(2);
    $(".total-freight").text(totalFreight)
    $(".product-total").text(productTotal);
    $(".total").text(total);
  });
}

function getlocalStorager() {
  var shoppingCart = $.localStorage.get("shoppingCart");
  var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
  return JsonStr.productList;
}

function updateBuyMark(id, num, mark) {
  var shoppingCart = $.localStorage.get("shoppingCart");
  var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
  var productList = JsonStr.productList;
  //查找购物车中是否有该商品
  for (var i in productList) {
    if (productList[i].id == id) {
      productList[i].buyMark = mark;
      productList[i].num = num;
    }
  }
  //保存购物车
  $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
}

function showProduct() {
  var productList = getlocalStorager();
  var length = productList.length;
  $(".totalproduct").text(length);
  if (length == 0) {
    $(".freight").text(0);
    $(".mesg").show();
    $(".product").remove();
    $(".shopping-cart-mark").hide();
    $("hr").hide();
  } else {
    $(".mesg").hide();
    for (i = 0; i < length; i++) {

      var id = productList[i].id;
      var name = productList[i].name;
      var englishname = productList[i].englishname;
      var num = productList[i].num;
      var price = productList[i].price;
      price = price.substring(2, price.length);
      price = parseFloat(price);
      var img = productList[i].img;
      var subtotal = num * price;
      var id = "product" + i;
      var product = $("<div></div>").addClass("product").attr("id", id);
      $(".select").before(product);
      var productId = $("<input>").attr("type", "hidden").attr("value", productList[i].id);
      $("#product" + i).append(productId);
      var pselect = $("<div></div>").addClass("p-select").addClass("pull-left");
      $("#product" + i).append(pselect);

      var checkbox = $("<input>").addClass("checkbox").attr("type", "checkbox");
      $("#product" + i).children(".p-select").append(checkbox);

      var pimg = $("<div></div>").addClass("p-img").addClass("pull-left");
      $("#product" + i).append(pimg);
      var img = $("<img></img>").attr("src", img);
      $("#product" + i).children(".p-img").append(img);

      var pintro = $("<div></div>").addClass("p-intro").addClass("pull-left");
      $("#product" + i).append(pintro);
      $("#product" + i).children(".p-intro").append("<p></P>");
      var spanname = $("<span></span>").addClass("text1").text(name);
      var spanenname = $("<span></span>").addClass("text1").text(englishname);
      $("#product" + i).children(".p-intro").children().append(spanname);
      $("#product" + i).children(".p-intro").children().append("<br/>");
      $("#product" + i).children(".p-intro").children().append(spanenname);

      var pamount = $("<div></div>").addClass("p-amount").addClass("pull-right");
      $("#product" + i).append(pamount);
      var pprice = $("<div></div>").addClass("price").addClass("text2").text("¥" + subtotal).attr("value", price);
      $("#product" + i).children(".p-amount").append(pprice);
      var ampuntaction = $("<div></div>").addClass("ampunt-action").addClass("pull-left");
      $("#product" + i).children(".p-amount").append(ampuntaction);
      var buttondec = $("<button></button>").addClass("action-de").attr("type", "button").text("-");
      $("#product" + i).children(".p-amount").children(".ampunt-action").append(buttondec);
      var number = $("<p></P>").addClass("number").text(num).attr("value", num);
      $("#product" + i).children(".p-amount").children(".ampunt-action").append(number);
      var buttonplus = $("<button></button>").addClass("action-plus").attr("type", "button").text("+");
      $("#product" + i).children(".p-amount").children(".ampunt-action").append(buttonplus);
      $("#product" + i).after("<hr>");
    }
  }
}
