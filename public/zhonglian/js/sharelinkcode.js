function getCode(name) {
  var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
  var r = window.location.search.substr(1).match(reg);
  if (r!=null) {
    return unescape(r[2]);
  }
  return null;
}

function updateShareLinkCode() {
  var name = "share_link_code";
  var shareLinkCode = getCode(name);
  var shoppingCart = $.localStorage.get("shoppingCart");
  var url = $.url();
  var newurl = url.attr( 'protocol' ) + '://' + url.attr( 'host' ) + ':' + url.attr( 'port' ) + url.attr( 'path' );
  var shareValue = url.attr( 'query' );
  if ( !shareLinkCode ) {
    if ( shareValue ) {
      window.location.href = newurl;
    }
    return;
  } else {
    if (shoppingCart === null || shoppingCart === "") {
      return;
    }
    else {
      var JsonStr = JSON.parse(shoppingCart.substr(1,shoppingCart.length));
      JsonStr.shareLinkCode = shareLinkCode;
      $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
      window.location.href = newurl;
    }
  }

}
