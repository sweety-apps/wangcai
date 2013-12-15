window.onload = function () {
	//window.location.href = "/wangcai_js/query_attach_phone";
};

function notifyPhoneStatus(isAttach, phone) {
	var noattach = document.getElementById("noattach");
	var isattach = document.getElementById("isattach");
	if ( isAttach ) {
		isattach.className = "isattach";
		noattach.className = "noattach hide";	
	} else {
		isattach.className = "isattach hide";
		noattach.className = "noattach";	
	}
}

function attachPhone() {
	window.location.href = "/wangcai_js/attach_phone";
}