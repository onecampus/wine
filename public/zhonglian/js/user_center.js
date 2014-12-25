// 判断有无商品交易记录
$(document).ready(function() {
	if (!$('.top').next().size()) {
		$('.main').append('<div class="announcement"><p>暂无记录</p></div>');
	}
});
