<?php
// ����������Ϣ
function getAppTaskInfo() {
	$obj = array();
	$obj['stepNum'] = 3;	// �ܵĲ�����
	$obj['curStep'] = 1;	// ��ǰ���뵽�ڼ���
	$obj['title'] = "����-�������";	// �������
	$obj['ico'] = "../img/ico.png";	// ����Сͼ��
	$obj['class'] = "��ͥ��Ϸ";
	$obj['desc'] = "������djskfjdskfjsd������djskfjdskfjsd������djskfjdskfjsd������djskfjdskfjsd������djskfjdskfjsd������djskfjdskfjsd������djskfjdskfjsd";
	$obj['installUrl'] = "http://www.qq.com";
	$obj['thumb'] = "../img/test.jpg";
	return $obj;
}

$appInfo = getAppTaskInfo();
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<link rel="stylesheet" type="text/css" href="app_task.css" />
<script src="app_task.js"></script>
<script>
var stepNum = <?php echo $appInfo['stepNum']; ?>;
var step = <?php echo $appInfo['curStep']; ?>;
</script>
</head>

<body>
<div id="step1" class="step hide">
	<div class="appinfo">
		<div class="ico">
			<img width="78px" height="78px" src="<?php echo $appInfo['ico']; ?>" />
		</div>
		<div class="info">
			<div class="title"><?php echo $appInfo['title']; ?></div>
			<div class="class">���<?php echo $appInfo['class']; ?></div>
			<div class="descTitle">����</div>
			<div class="desc"><?php echo $appInfo['desc']; ?></div>
		</div>
		<div class="clear">
		</div>
	</div>
	<div class="install">
		<a href="<?php echo $appInfo['installUrl']; ?>" target="_blank">
			<img src="../img/btnBkg.png" />
		</a>
	</div>
</div>
<?php
if ( $appInfo['stepNum'] == 3 ) {
?>
<div class="step hide" id="step2">
	<div class="appinfo">
		<div class="ico">
			<img width="78px" height="78px" src="<?php echo $appInfo['ico']; ?>" />
		</div>
		<div class="info">
			<div class="title"><?php echo $appInfo['title']; ?></div><br />
			<div class="tip">��װ�ɹ���<br/>��������ע��</div>
		</div>
		<div class="clear">
		</div>
	</div>
	<div class="thumb">
		<img src="<?php echo $appInfo['thumb']; ?>" />
	</div>
</div>
<?php
}
?>

<div class="step hide" id="step<?php echo ($appInfo['stepNum']==3 ? 3 : 2); ?>">
	<div class="suc">
		<img src="../img/success.png" width="291px" />
	</div>
	<div class="install">
		<a href="" target="_blank">
			<img src="../img/award1.png" width="291px" />
		</a>
	</div>
</div>

</body>
</html>
