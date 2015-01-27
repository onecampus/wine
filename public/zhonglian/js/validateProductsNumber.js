// 数量改变事件
$(document).ready(function(){
  $( ".p-num" ).on('change',function(){
    var checkNum = "^[0-9]*[1-9][0-9]*$";
    var regNum = new RegExp(checkNum);
    var num = $(this).val();
    var price = $(this).parent().siblings().attr("value");
    if(num <= 0 ) {
      alert("购买数量不能小于1");
      $(this).attr("value",1);
    }
    else if (isNaN(num)) {
      alert("请输入整数");
      $(this).attr("value",1);
    }
    else if (!regNum.test(num)) {
      alert("请输入整数");
      $(this).attr("value",1);
    }
    else {
      console.log( "succeed" );
    }
  });

  // 判断商品评价desc有无子元素
  var $p = $( ".desc" ).find( "p" );
  if ( !$p.length ) {
    $( ".desc" ).css( "margin-left", "20px" );
  }
});
