<?php
function getExchangeInfo() {
	$obj = array();

	// ��¼1
	$tmp = array();
	
	array_push($tmp, "2013-11-12");

	$text = array();
	$text['type'] = 2;	// 1.��ɫȦ	 2.��ɫȦ  ��ɫ������ɫ��
	$text['coin'] = 10;
	$text['info'] = "�һ�10Ԫ����";
	$text['num'] = 182371831;
	array_push($tmp, $text);
	
	array_push($obj, $tmp);
	
	// ��¼2
	$tmp = array();
	
	array_push($tmp, "2013-11-13");
	
	$text = array();
	$text['type'] = 10;	// 1.��ɫȦ	 2.��ɫȦ  ��ɫ������ɫ��
	$text['coin'] = 3;
	$text['info'] = "������������";
	array_push($tmp, $text);
	
	$text = array();
	$text['type'] = 1;
	$text['coin'] = 3;
	$text['info'] = "ǩ���齱";
	array_push($tmp, $text);
	
	$text = array();
	$text['type'] = 1;
	$text['coin'] = 3;
	$text['info'] = "�״ΰ�װ����";
	array_push($tmp, $text);
	
	array_push($obj, $tmp);
	
	// ��¼3
	$tmp = array();
	
	array_push($tmp, "2013-11-14");
	
	$text = array();
	$text['type'] = 10;	// 1.��ɫȦ	 2.��ɫȦ  ��ɫ������ɫ��
	$text['coin'] = 3;
	$text['info'] = "������������";
	array_push($tmp, $text);
	
	$text = array();
	$text['type'] = 10;	// 1.��ɫȦ	 2.��ɫȦ  ��ɫ������ɫ��
	$text['coin'] = 3;
	$text['info'] = "������������";
	array_push($tmp, $text);
	
	$text = array();
	$text['type'] = 10;	// 1.��ɫȦ	 2.��ɫȦ  ��ɫ������ɫ��
	$text['coin'] = 3;
	$text['info'] = "������������";
	array_push($tmp, $text);
	
	array_push($obj, $tmp);
	
	return $obj;
}

$data = getExchangeInfo();
?>

<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="exchange_info.css" />
<!-- <script src="exchange_info.js"></script> -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

</head>
<body>
	<div class="header">
		<img src="./img/exchange_head.png" width="320px" />
		<div class="info">
			<table border="0">
				<tr>
					<th>231.1</th>
					<th class="symbol">-</th>
					<th>10.0</th>
					<th class="symbol">=</th>
					<th>228.1</th>
				</tr>
				<tr class="desc">
					<th>������</th>
					<th class="symbol"></th>
					<th>֧��</th>
					<th class="symbol"></th>
					<th>���</th>
				</tr>
			</table>
		</div>
	</div>
	<div class="exchangeinfo">
<?php
	foreach ( $data as $info ) {
?>
		<div class="item">
			<div class="date">
				<?php echo $info[0]; ?>
			</div>
			<div class="info">
<?php
			for ($i = 1; $i < count($info); $i ++ ) {
				$item = $info[$i];
				if ( $item['type'] == 1 ) {
					$img = "./img/withdraw.png";
				} else {
					$img = "./img/buy.png";
				}
?>
				<div class="left">
					<div class="fl_img">
						<img src="<?php echo $img; ?>" width="11px" />
					</div>
					<div class="fl">
						<?php echo $item['info']; ?>
					</div>
					<div class="clear"></div>
<?php
				if ( array_key_exists('num', $item) ) {
?>
					<div class="ordernumber fl">
						<div class="fl_img">
						</div>
						<div class="fl">
							���ţ�<a href="/wangcai_js/order_info?num=<?php echo $item['num']; ?>"><font><?php echo $item['num']; ?></font></a>
						</div>
						<div class="clear"></div>
					</div>
<?php
				}
?>
				</div>
				<div class="right">
<?php
				if ( $item['type'] == 1 ) {
					echo '���'.$item['coin'].'Ԫ';
				} else {
					echo '֧��'.$item['coin'].'Ԫ';
				}
?>
				</div>
				<div class="clear"></div>
<?php
			}
?>
			</div>
			<div class="clear"></div>
			<img src="./img/line.png" width="320px" height="1px" />
		</div>
<?php
	}
?>
	</div>
</body>
</html>
