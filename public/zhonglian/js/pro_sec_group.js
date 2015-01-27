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

  // 点击分享按钮，弹出引导框
  $( '.share' ).on( 'click', function() {
    $( '.back' ).show();
    $( '.share_notice' ).slideDown(800);
    setTimeout( function() {
      $( '.back' ).hide();
      $( '.share_notice' ).slideUp(800);
    },3000);
  });
});

// 判断是否为微信内置浏览器函数
function isWechat(){
  var ua = navigator.userAgent.toLowerCase();
  if(ua.match( /MicroMessenger/i )=="micromessenger") {
    return true;
  } else {
    return false;
  }
}
