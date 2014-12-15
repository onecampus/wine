(function(){$(document).on('ready page:load',function(){
    showProduct();
    total();
    $(".checkbox").click(function(){
    	total();
    });
    /*全选
    */
    $(".allselect").click(function(){
      $(".checkbox").each(function(){
      	this.checked=true;
        });
      total();
      });
    /*
    反选
    */
      $(".inselect").click(function(){
        $(".checkbox").each(function(){
        	this.checked=!this.checked;
        });
        total();
      });
      /*
      number plus
      */
      $(".action-plus").click(function(){
         var num = parseInt($(this).siblings("p").text());
         num = num+1;
         var subtotal = 0;
         var price = $(this).parent().siblings().attr("value");
         price = parseFloat(price);
         subtotal = (Number(num * price)).toFixed(2);
         $(this).parent().siblings().text("¥"+subtotal);
         $(this).siblings("p").text(num);
         total();
      });
      /*
      number dec
      */
      $(".action-de").click(function(){
         var num = parseInt($(this).siblings("p").text());
         if (num==0){
         	return;
         }
         else {
         	  num = num-1;
            var subtotal = 0;
            var price = $(this).parent().siblings().attr("value");
            price = parseFloat(price);
            subtotal = (Number(price * num)).toFixed(2);
         	  $(this).parent().siblings().text("¥"+subtotal);
         	  $(this).siblings("p").text(num);
         	  total();
         }
      });
    });
}).call(this);
  /*
  合计
  */
  function total() {
    	var total = 0.00;
    	$(".checkbox").each(function(){
    	  if(($(this).is(':checked'))==true){
          total = parseFloat(total);
          subtotal = $(this).parent().siblings(".p-amount").children(".price").text();
    	  	subtotal = parseFloat(subtotal.substring(1,subtotal.length));
    	  	total = (Number(total + subtotal)).toFixed(2);
    	  }
    	  $(".total").text(total);
    	});
    }

    function getlocalStorager(){
      var shoppingCart = $.localStorage.get("shoppingCart");
      var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
      return JsonStr.productList;
    }

    function showProduct() {
      var productList = getlocalStorager();
      var length = productList.length;
      $(".totalproduct").text(length);
      if (length==0) {
        $(".mesg").show();
      }
      else {
        $(".mesg").hide();
        for(i=0;i<length;i++) {

          var id = productList[i].id;
          var name = productList[i].name;
          var englishname = productList[i].englishname;
          var num = productList[i].num;
          var price = productList[i].price;
          price = price.substring(2,price.length);
          price = parseFloat(price);
          var img = productList[i].img;
          var subtotal = num*price;

          var id = "product" + i;
          var product = $("<div></div>").addClass("product").attr("id",id);
          $(".select").before(product);
          var pselect = $("<div></div>").addClass("p-select").addClass("pull-left");
          $("#product"+i).append(pselect);

          var checkbox = $("<input>").addClass("checkbox").attr("type","checkbox");
          $("#product"+i).children(".p-select").append(checkbox);

          var pimg = $("<div></div>").addClass("p-img").addClass("pull-left");
          $("#product"+i).append(pimg);
          var img = $("<img></img>").attr("src",img);
          $("#product"+i).children(".p-img").append(img);

          var pintro = $("<div></div>").addClass("p-intro").addClass("pull-left");
          $("#product"+i).append(pintro);
          $("#product"+i).children(".p-intro").append("<p></P>");
          var spanname = $("<span></span>").addClass("text1").text(name);
          var spanenname = $("<span></span>").addClass("text1").text(englishname);
          $("#product"+i).children(".p-intro").children().append(spanname);
          $("#product"+i).children(".p-intro").children().append("<br/>");
          $("#product"+i).children(".p-intro").children().append(spanenname);

          var pamount = $("<div></div>").addClass("p-amount").addClass("pull-right");
          $("#product"+i).append(pamount);
          var pprice = $("<div></div>").addClass("price").addClass("text2").text("¥"+subtotal).attr("value",price);
          $("#product"+i).children(".p-amount").append(pprice);
          var ampuntaction = $("<div></div>").addClass("ampunt-action").addClass("pull-left");
          $("#product"+i).children(".p-amount").append(ampuntaction);
          var buttondec = $("<button></button>").addClass("action-de").attr("type","button").text("-");
          $("#product"+i).children(".p-amount").children(".ampunt-action").append(buttondec);
          var number = $("<p></P>").addClass("number").text(num);
          $("#product"+i).children(".p-amount").children(".ampunt-action").append(number);
          var buttonplus = $("<button></button>").addClass("action-plus").attr("type","button").text("+");
          $("#product"+i).children(".p-amount").children(".ampunt-action").append(buttonplus);
          $("#product"+i).after("<hr>");

      }
    }
  }
