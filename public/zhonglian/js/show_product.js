$(document).ready(function(){
  updateShareLinkCode();
  updateInviteCode();
});

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
  if (shoppingCart === null || shoppingCart === "") {
    return;
  }
  else {
    var JsonStr = JSON.parse(shoppingCart.substr(1,shoppingCart.length));
    JsonStr.shareLinkCode = shareLinkCode;
    $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
  }
}

function updateInviteCode() {
  var name = "invite_code";
  var invitecode = getCode(name);
  var shoppingCart = $.localStorage.get("shoppingCart");
  if (shoppingCart === null || shoppingCart === "") {
    return;
  }
  else {
    var JsonStr = JSON.parse(shoppingCart.substr(1,shoppingCart.length));
    JsonStr.inviteCode = invitecode;
    $.localStorage.set("shoppingCart", "'" + JSON.stringify(JsonStr));
  }
}
