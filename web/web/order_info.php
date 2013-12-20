<?php
function getData($num) {
	$obj = array();
	$obj['title'] = "�һ�Ѹ�׻�Ա30��";
	$obj['id'] = "13687878787";
	$obj['coin'] = 30;
	$obj['status'] = 2;	// 1������,2���
	
	$obj['details'] = array();	
	
	$tmp = array();
	$tmp[0] = "2013-11-01 21:33";
	$tmp[1] = "�ύ";
	array_push($obj['details'], $tmp);
	
	$tmp = array();
	$tmp[0] = "2013-11-02 21:33";
	$tmp[1] = "����ȷ��";
	array_push($obj['details'], $tmp);
	
	$tmp = array();
	$tmp[0] = "2013-11-03 21:33";
	$tmp[1] = "��ת��";
	array_push($obj['details'], $tmp);
	
	$obj['code'] = array();
	$obj['code'][0] = "�����룺";
	$obj['code'][1] = "11213213213213214324";
	
	return $obj;
}

$data = getData($_GET['ordernum']);
?>

<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="order_info.css" />
<!-- <script src="exchange_info.js"></script> -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

</head>
<body>
	<div class="head">
		<div class="title">
			<?php echo $data['title']; ?>
		</div>
		<div class="status">
			<div class="label">״̬��</div>
		<?php
		if ( $data['status'] == '1' ) {
		?>
			<div class="info process">������</div>
		<?php
		} else {
		?>
			<div class="info completed">���</div>
		<?php
		}
		?>
			<div class="clear"></div>
		</div>
		<div class="loginid">
			<div class="label">�˺ţ�</div>
			<div class="info"><?php echo $data['id']; ?></div>
			<div class="clear"></div>
		</div>
		<div class="coin">
			<div class="label">��</div>
			<div class="info"><?php echo $data['coin']; ?></div>
			<div class="clear"></div>
		</div>
	</div>
	<div class="details">
	<?php
		foreach ($data['details'] as $item ) {
	?>
		<div class="item">
			<div class="date">
				<?php echo $item[0]; ?>
			</div>
			<div class="desc">
				<?php echo $item[1]; ?>
			</div>
			<div class="clear"></div>
		</div>
	<?php
		}
	?>
	</div>
	
	<div class="code">
	<?php
	if ( array_key_exists('code', $data) ) {
	?>
		<div class="text">
			<?php echo $data['code'][0]; ?>
			<?php echo $data['code'][1]; ?>
		</div>
		<a href="#"><div class="help">ʹ�ð���</div></a>
		<a href="/wangcai_js/copy_to_clip?context=<?php echo $data['code'][1]; ?>"><div class="copy">���Ƶ�������</div></a>
	<?php
	}
	?>
	</div>
	
	<div class="userService">
		<a href="">
			<img src="./img/userservice.png" width="66px" />
		</a>
	</div>
</body>
</html>