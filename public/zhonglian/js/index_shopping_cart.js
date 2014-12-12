(function(){$(document).on('ready page:load',function(){
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
         num=num+1;
         var price = $(this).parent().siblings().text();
         price=price.substring(1,price.length);
         price=parseInt(price);
         price+=600;
         $(this).parent().siblings().text("Y"+price);
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
         	  num=num-1;
         	  var price = $(this).parent().siblings().text();
         	  price=price.substring(1,price.length);
      	  price=parseInt(price);
         	  price-=600;
         	  $(this).parent().siblings().text("Y"+price);
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
    	var total = 0;
    	$(".checkbox").each(function(){
    	  if(($(this).is(':checked'))==true){
    	  	var id=$(this).attr("id");
    	  	price = $("#"+id+"-price").text();
    	  	price = parseInt(price.substring(1,price.length));
    	  	total +=price;
    	  }
    	  $(".total").text(total);
    	});
    }