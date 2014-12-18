(function() {
  $(document).on('ready page:load', function() {
    showProduct();
    $(".order-address").click(function(){
      $("hr").hide();
      $(".order").hide();
      $(".address").fadeIn(1000);
    });
    $(".cancel").click(function(){
      $("hr").show();
      $(".address").fadeOut(100);
      $(".order").show();
    });
    $(".confirm").click(function(){
      var id = $('input[name="shipaddress"]:checked').val();
      var address= $('input[name="shipaddress"]:checked').parent().siblings(".p-m").children(".selected-address").text();
      $(".confirm-address").text(address);
      $(".address-id").val(id);
      $("hr").show();
      $(".address").fadeOut(100);
      $(".order").show();
    });
    $(".address-add").click(function(){
      $("hr").hide();
      $(".order").hide();
      $(".address").fadeOut(100);
      $(".form-box").fadeIn(1000);
    });
    $(".cancel-add-addre").click(function(){
      $(".form-box").hide();
      $(".address").fadeIn(1000);
    });
    $(".invoice-need").click(function(){
      $("hr").hide();
      $(".order").hide();
      $(".order-address").hide();
      $(".invoice-need").hide();
      $(".invoice-inf").fadeIn(1000);
    });

    $(".cancel-invoice").click(function(){
      $(".invoice-status").val(0);
      $(".invoice-inf").fadeOut(100);
      $("hr").show();
      $(".order").show();
      $(".order-address").show();
      $(".invoice-need").show();
    });
  });
}).call(this);

function getlocalStorager() {
  var shoppingCart = $.localStorage.get("shoppingCart");
  var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
  return JsonStr.productList;
}

function showProduct() {
  var productList = getlocalStorager();
  var total = 0.00;
  for (var i in productList) {
    if (productList[i].buyMark == true) {
      total = parseFloat(total);
      var imgPath = productList[i].img,
          name = productList[i].name,
          englishName = productList[i].englishname,
          num = productList[i].num,
          price = productList[i].price,
          subtotal = (Number(parseFloat(price.substr(2,price.length)) * parseInt(num))).toFixed(2);
      subtotal = parseFloat(subtotal);
      total = (Number(total + subtotal)).toFixed(2);
      var product = $("<div></div>").addClass("product").attr("id","product"+i);
      $(".submit-order").before(product);
      var productImg = $("<div></div>").addClass("product-img").addClass("pull-left");
      $("#product"+i).append(productImg);
      var img = $("<img>").attr("src",imgPath);
      $("#product"+i).children(".product-img").append(img);
      var productInf = $("<div></div>").addClass("product-inf").addClass("pull-left");
      $("#product"+i).append(productInf);
      var productName = $("<p></p>").addClass("text1").text(name);
      $("#product"+i).children(".product-inf").append(productName);
      var account = $("<p></p>").addClass("account");
      $("#product"+i).children(".product-inf").append(account);
      var productPrice = $("<span></span>").addClass("text2").text(price);
      var productNum = $("<span></span>").addClass("text3").text("x"+num);
      $("#product"+i).children(".product-inf").children(".account").append(productPrice);
      $("#product"+i).children(".product-inf").children(".account").append(productNum);
      $("#product"+i).after("<hr>");
    }
  }
  $(".submit-order").children(".text2").text("￥"+total);
}
