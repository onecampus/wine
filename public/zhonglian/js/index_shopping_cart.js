$(document).ready(function() {
  showProduct();
  total();
  checkShoppingCart();
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
    var num = parseInt($(this).siblings("input").val());
    num = num + 1;
    var subtotal = 0;
    var price = $(this).parent().siblings().attr("value");
    price = parseFloat(price);
    subtotal = (Number(num * price)).toFixed(2);
    $(this).parent().siblings().text("¥" + subtotal);
    $(this).siblings("input").attr("value",num);
    total();
  });
  /*
  number dec
  */
  $(".action-de").click(function() {
    var num = parseInt($(this).siblings("input").val());
    if (num < 1 || num == 1) {
      $(this).siblings("p").text(1);
      alert("购买数量不能为0");
    } else {
      num = num - 1;
      var subtotal = 0;
      var price = $(this).parent().siblings().attr("value");
      price = parseFloat(price);
      subtotal = (Number(price * num)).toFixed(2);
      $(this).parent().siblings().text("¥" + subtotal);
      $(this).siblings("input").attr("value",num);
      total();
    }
  });
/*
结算
*/
  $(".account").click(function() {
    var select = 0;
    $(".checkbox").each(function() {
      if (($(this).is(':checked')) == true) {
        var id = ($(this).parent().siblings("input").val());
        var num = $(this).parent().parent().children(".p-amount").children(".ampunt-action").children(".number").val();
        updateBuyMark(id, num, true);
        select = select + 1;
      }
      if (($(this).is(':checked')) == false) {
        var id = ($(this).parent().siblings("input").val());
        var num = $(this).parent().parent().children(".p-amount").children(".ampunt-action").children(".number").val();
        updateBuyMark(id, num, false);
      }
    });
    updateProductMark();
    var total = $(".total").text();
    var shoppingCart = $.localStorage.get("shoppingCart");
    if (shoppingCart === null || shoppingCart === "") {
      return;
    }
    else {
      var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
      var productList = JsonStr.productList;
      JsonStr.totalAmount = total;
      JsonStr.order_type = "is_product";
      $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
      var length = 0;
      for (i in productList) {
        if(productList[i].productType == "product") {
          length = length +1;
        }
      }
      if(length == 0 || select == 0) {
        return;
      }
      else{
        $(this).attr("href", "/customer/orders/settlement");
      }
    }
  });
  /*
  清空购物车
  */
  $(".cleancart").click(function(){
    var shoppingCart = $.localStorage.get("shoppingCart");
    if (shoppingCart === null || shoppingCart === "") {
      return;
    }
    else {
      $.localStorage.set("shoppingCart","");
      $(".total-freight").text(0);
      $(".total").text(0);
      $(".product-total").text(0);
      showProduct();
      showShoppingCartItem();
      $(".allselect").attr("disabled","disabled");
      $(".inselect").attr("disabled","disabled");
      $(".cleancart").attr("disabled","disabled");
    }
  });
  /*
  数量改变事件
  */
  $(".number").on('change',function(){
    var checkNum = "^[0-9]*[1-9][0-9]*$";
    var regNum = new RegExp(checkNum);
    var num = $(this).val();
    var price = $(this).parent().siblings().attr("value");
    if(num <= 0 ) {
      alert("购买数量不能小于1");
      $(this).attr("value",1);
      $(this).parent().siblings().text("¥" + price);
    }
    else if (isNaN(num)) {
      alert("请输入整数");
      $(this).attr("value",1);
      $(this).parent().siblings().text("¥" + price);
    }
    else if (!regNum.test(num)) {
      alert("请输入整数");
      $(this).attr("value",1);
      $(this).parent().siblings().text("¥" + price);
    }
    else {
      var subtotal = 0;
      price = parseFloat(price);
      subtotal = (Number(num * price)).toFixed(2);
      $(this).parent().siblings().text("¥" + subtotal);
      total();
    }
  });

});
/*
合计
*/
function total() {
  var total = 0.00,
      productTotal = 0.00,
      totalFreight = 0.00,
      shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
      return;
  }
  else {
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var  productList = JsonStr.productList;
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
}


function updateBuyMark(id, num, mark) {
  var shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
    return;
  }
  else{
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var productList = JsonStr.productList;
    //查找购物车中是否有该商品
    for (var i in productList) {
      if (productList[i].id == id && productList[i].productType == "product") {
        productList[i].buyMark = mark;
        productList[i].num = num;
      }
    }
    //保存购物车
    $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
  }
}

function updateProductMark() {
  var shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
    return;
  }
  else{
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var productList = JsonStr.productList;
    //查找购物车中是否有该商品
    for (var i in productList) {
      if (productList[i].productType != "product") {
        productList[i].buyMark = false;
      }
    }
    //保存购物车
    $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
  }
}

function showProduct() {
  var shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
    $(".mesg").show();
    $(".product").remove();
    $("hr").remove();
    return;
  }
  else{
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var productList = JsonStr.productList;
    if(productList == null){
      $(".mesg").show();
      $(".product").remove();
      $("hr").remove();
      return;
    }
    else {
      var subtotal = 0.00;
      var length = 0;
      for(i in productList) {
        if(productList[i].productType == "product") {
          length = length + 1;
        }
      }
      if (length == 0) {
        $(".total-freight").text(0);
        $(".mesg").show();
        $(".product").remove();
        $(".shopping-cart-mark").hide();
        $("hr").hide();
      }
      else {
          $(".mesg").hide();
          for (i = 0; i < productList.length; i++) {
            if(productList[i].productType == "product") {
              var id = productList[i].id;
              var name = productList[i].name;
              var englishname = productList[i].englishname;
              var num = productList[i].num;
              var price = productList[i].price;
              num = parseInt(num);
              price = price.substring(2, price.length);
              price = parseFloat(price);
              var img = productList[i].img;
              subtotal = (Number(num * price)).toFixed(2);
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

              var pamount = $("<div></div>").addClass("p-amount");
              $("#product" + i).append(pamount);
              var pprice = $("<div></div>").addClass("price").addClass("text2").text("¥" + subtotal).attr("value", price);
              $("#product" + i).children(".p-amount").append(pprice);
              var ampuntaction = $("<div></div>").addClass("ampunt-action").addClass("pull-left");
              $("#product" + i).children(".p-amount").append(ampuntaction);
              var buttondec = $("<button></button>").addClass("action-de").attr("type", "button").text("-");
              $("#product" + i).children(".p-amount").children(".ampunt-action").append(buttondec);
              var number = $("<input></input>").addClass("number").attr("value", num).attr("type","text");
              $("#product" + i).children(".p-amount").children(".ampunt-action").append(number);
              var buttonplus = $("<button></button>").addClass("action-plus").attr("type", "button").text("+");
              $("#product" + i).children(".p-amount").children(".ampunt-action").append(buttonplus);
              $("#product" + i).after("<hr>");
            }
          }
      }
    }
  }
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

function checkShoppingCart(){
  var shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
    $(".allselect").attr("disabled","disabled");
    $(".inselect").attr("disabled","disabled");
    $(".cleancart").attr("disabled","disabled");
  }
  else {
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var productList = JsonStr.productList;
    if (productList == null || productList == "") {
      $(".allselect").attr("disabled","disabled");
      $(".inselect").attr("disabled","disabled");
      $(".cleancart").attr("disabled","disabled");
    }
  }
}
