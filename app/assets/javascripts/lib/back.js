
$(document).ready(function() {
  var backUrl = $.localStorage.get('back_url');
  if(backUrl !== undefined && backUrl !== '') {
    window.location.href = backUrl;
  }
});
