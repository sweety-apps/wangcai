<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="extract_money.css" />
<script src="extract_money.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

</head>
<body>
	<div class="header">
		<div id="noattach" class="noattach">
			<div class="info">
			您还没有绑定手机,为了有效兑换,请先
			</div>
			<input type="button" value="绑定手机" class="btn" onClick="attachPhone()" />
			<div class="clear"></div>
			<div class="tip">请先绑定手机</div>
		</div>
		<div id="isattach" class="isattach hide">
			<div class="info">
			可用余额：
			</div>
			<div class="money">
			￥22
			</div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="bdy">
		<a href="/wangcai_js/pay_to_alipay?coin=5.0">
			转账到支付宝
		</a>
		
		手机充值
		<a href="/wangcai_js/pay_to_phone?coin=5.0">
			话费充值
		</a>
	</div>
</body>
</html>
