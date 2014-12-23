$(document).ready(function() {
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
    shareLinkCode: null
  };
  var Cart = {
    //向购物车中添加商品
    addProduct: function(product) {
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
            result = true;
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
        OrderDetail.totalNumber = JsonStr.totalNumber;
        OrderDetail.totalAmount = JsonStr.totalAmount;
        //保存购物车
        Utils.setParam("shoppingCart", "'" + JSON.stringify(JsonStr));
      }
    },
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
        OrderDetail.totalNumber = JsonStr.totalNumber;
        OrderDetail.totalAmount = JsonStr.totalAmount;
        //保存购物车
        Utils.setParam("shoppingCart", "'" + JSON.stringify(JsonStr));
      }
      var shoppingCart = $.localStorage.get("shoppingCart");
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
  };
  /*
  加入购物车
  */
  $("#input-shoppingcart").click(function() {
    var name = $(".product-name").text(),
        englishname = $(".product-englishname").text(),
        price = $(".price").text(),
        num = $(".p-num").val(),
        id = $(".product-id").val(),
        img = $(".top-img").children().attr("src"),
        freight = $(".freight-price").text();
        buyMark = false;
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
    Cart.addProduct(product);
    showShoppingCartItem();
  });

  /*
  立即购买
  */
  $(".buy-now").click(function(){
    var name = $(".product-name").text(),
    englishname = $(".product-englishname").text(),
    price = $(".price").text(),
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
    showShoppingCartItem();
    window.location = '/customer/orders/settlement';
  });

  updateShareLinkCode();
});

function showShoppingCartItem() {
  var shoppingCart = $.localStorage.get("shoppingCart");
  console.log("shoppingCart is " + shoppingCart);
  if(shoppingCart !== null) {
    var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
    var productList = JsonStr.productList;
    var length = productList.length;
    if (length > 0) {
      $(".shopping-cart-mark").show();
      $(".shopping-cart-mark").text(length);
    } else {
      $(".shopping-cart-mark").hide();
    }
  }
}
function getShareLinkCode(name) {
  var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
  var r = window.location.search.substr(1).match(reg);
  if (r!=null) {
    return unescape(r[2]);
  }
  return null;
}

function updateShareLinkCode() {
  var name = "share_link_code";
  var shareLinkCode = getShareLinkCode(name);
  var shoppingCart = $.localStorage.get("shoppingCart");
  var JsonStr = JSON.parse(shoppingCart.substr(1,shoppingCart.length));
  JsonStr.shareLinkCode = shareLinkCode;
  $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
}
