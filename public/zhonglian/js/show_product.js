$(document).ready(function(){
  updateShareLinkCode();
});

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
