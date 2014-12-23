$(document).ready(function() {
  showProduct();
  $(".order-address").click(function() {
    $("hr").hide();
    $(".order").hide();
    $(".address").fadeIn(1000);
  });
  $(".cancel").click(function() {
    $("body").css("background","#f2f2f2");
    $("hr").show();
    $(".address").fadeOut(100);
    $(".order").show();
  });
  $(".confirm").click(function() {
    $("body").css("background","#f2f2f2");
    var id = $('input[name="shipaddress"]:checked').val();
    var address = $('input[name="shipaddress"]:checked').parent().siblings(".p-m").children(".selected-address").text();
    $(".confirm-address").text(address);
    $(".address-id").val(id);
    $("hr").show();
    $(".address").fadeOut(100);
    $(".order").show();
  });
  $(".address-add").click(function() {
    $("body").css("background","#fff");
    $("hr").hide();
    $(".order").hide();
    $(".order-address").hide();
    $(".invoice-need").hide();
    $(".address").fadeOut(100);
    $(".form-box").fadeIn(1000);
  });
  $(".cancel-add-addre").click(function() {
    $(".form-box").hide();
    $(".order-address").show();
    $(".invoice-need").show();
    $(".address").fadeIn(1000);
  });
  $(".invoice-need").click(function() {
    $("hr").hide();
    $(".invoice-hr").show();
    $(".order").hide();
    $(".order-address").hide();
    $(".invoice-need").hide();
    $(".invoice-history").fadeIn(1000);
  });

  $(".cancel-invoice").click(function() {
    $(".invoice-id").val(0);
    $(".invoice-not").text("不开发票");
    $(".invoice-not").css("color", "#000000")
    $(".invoice-history").hide();
    $(".invoice-inf").hide();
    $("hr").show();
    $(".invoice-hr").hide();
    $(".order").show();
    $(".order-address").show();
    $(".invoice-need").show();
  });

  $(".add-new-invoice").click(function(){
    $(".invoice-history").fadeOut(100);
    $(".invoice-inf").show();
  });

  $(".cancel-history-invoice").click(function() {
    $(".invoice-id").val(0);
    $(".invoice-not").text("不开发票");
    $(".invoice-not").css("color", "#000000")
    $(".invoice-history").hide();
    $("hr").show();
    $(".invoice-hr").hide();
    $(".order").show();
    $(".order-address").show();
    $(".invoice-need").show();
  });

  $(".confirm-history-invoice").click(function(){
    var id = $('input[name="invoice"]:checked').val();
    $(".invoice-id").val(id);
    $(".invoice-not").text("开发票");
    $(".invoice-not").css("color", "#aa0c40");
    $(".invoice-history").hide();
    $("hr").show();
    $(".invoice-hr").hide();
    $(".order").show();
    $(".order-address").show();
    $(".invoice-need").show();
  });
});

function showProduct() {
  var shoppingCart = $.localStorage.get("shoppingCart");
  var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
  var productList = JsonStr.productList;
  var total = JsonStr.totalAmount;
  for (var i in productList) {
    if (productList[i].buyMark == true) {
      var imgPath = productList[i].img,
        name = productList[i].name,
        englishName = productList[i].englishname,
        num = productList[i].num,
        price = productList[i].price,
        subtotal = (Number(parseFloat(price.substr(2, price.length)) * parseInt(num))).toFixed(2);
      subtotal = parseFloat(subtotal);
      var product = $("<div></div>").addClass("product").attr("id", "product" + i);
      $(".submit-order").before(product);
      var productImg = $("<div></div>").addClass("product-img").addClass("pull-left");
      $("#product" + i).append(productImg);
      var img = $("<img>").attr("src", imgPath);
      $("#product" + i).children(".product-img").append(img);
      var productInf = $("<div></div>").addClass("product-inf").addClass("pull-left");
      $("#product" + i).append(productInf);
      var productName = $("<p></p>").addClass("text1").text(name);
      $("#product" + i).children(".product-inf").append(productName);
      var account = $("<p></p>").addClass("account");
      $("#product" + i).children(".product-inf").append(account);
      var productPrice = $("<span></span>").addClass("text2").text(price);
      var productNum = $("<span></span>").addClass("text3").text(" x " + num);
      $("#product" + i).children(".product-inf").children(".account").append(productPrice);
      $("#product" + i).children(".product-inf").children(".account").append(productNum);
      $("#product" + i).after("<hr>");
    }
  }
  $(".submit-order").children(".text2").text("￥" + total);
}
