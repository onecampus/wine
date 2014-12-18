(function() {
  $(document).on('ready page:load', function() {
    showProduct();
    $(".order-address").click(function(){
      $("hr").hide();
      $(".address").fadeIn(1000);
    });
    $(".cancel").click(function(){
      $("hr").show();
      $(".address").fadeOut(100);
    });
    $(".confirm").click(function(){
      $("hr").show();
      $(".address").fadeOut(100);
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
  for (var i in productList) {
    if (productList[i].buyMark == true) {
      var imgPath = productList[i].img,
          name = productList[i].name,
          englishName = productList[i].englishname,
          num = productList[i].num,
          price = productList[i].price;

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
}