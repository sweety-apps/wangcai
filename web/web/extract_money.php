<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="extract_money.css" />
<script src="extract_money.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

</head>
<body>
	<div class="product">
	<div class="header">
		<div id="noattach" class="noattach">
			<img src="./img/warn.png" width="17px" />
			<div class="info">����û�а��ֻ�,Ϊ����Ч�һ�</div>
		
			<div class="attachphone" onClick="attachPhone()">
				<img src="./img/attachphone.png" width="74px" />
				<div class="attachphonetext">���ֻ���</div>
			</div>
		</div>
		<div id="isattach" class="isattach">
			<img src="./img/BindTipsDuihao.png" width="17px" />
			<div class="info">������<span>22.3</span></div>
			<a href="/wangcai_js/exchange_info">
				<img class="btn" src="./img/exchange.png" width="74px" />
			</a>
		</div>
	</div>
	
	<div class="bdy">
		<img src="./img/alipay.png" width="65px" />
		<div class="alipay_select">
			��ѡ����ȡ���:
		</div>
		<div class="select">
			<div class="item" onClick="clickAlipay(5)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">5Ԫ</div>
			</div>
			<div class="item" onClick="clickAlipay(10)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">10Ԫ</div>
			</div>
			<div class="item" onClick="clickAlipay(20)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">20Ԫ</div>
			</div>
			<div class="item2" onClick="clickAlipay(30)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">30Ԫ</div>
				<div class="desc">����1Ԫ</div>
			</div>
			<div class="item2 last" onClick="clickAlipay(50)">
				<img src="./img/select_alipay.png" width="55px" />
				<div class="text">50Ԫ</div>
				<div class="desc">����5Ԫ</div>
			</div>
			<div class="clear"></div>
		</div>
		
		<img src="./img/phone.png" width="195px" style="margin-bottom:10px" />
		<div class="phone_select">
			<div class="item" onClick="clickPhone(10)">
				<img src="./img/phone_bkg.png" width="289px" />
				<div class="text">��ֵ10Ԫ</div>
			</div>
			<div class="item" onClick="clickPhone(30)">
				<img src="./img/phone_bkg.png" width="289px" />
				<div class="text">��ֵ30Ԫ<font color="#FF0000">(����29Ԫ)</font></div>
			</div>
			<div class="item" onClick="clickPhone(50)">
				<img src="./img/phone_bkg.png" width="289px" />
				<div class="text">��ֵ50Ԫ<font color="#FF0000">(����48Ԫ)</font></div>
			</div>
		</div>
		<!--
		<a href="/wangcai_js/pay_to_alipay?coin=5.0">
			ת�˵�֧����
		</a>
		
		�ֻ���ֵ
		<a href="/wangcai_js/pay_to_phone?coin=5.0">
			���ѳ�ֵ
		</a>
		-->
	</div>
	<!--
	<div class="banner">
		<img src="./img/banner.png" width="320px" />
	</div>
	-->
	</div>
</body>
</html>
