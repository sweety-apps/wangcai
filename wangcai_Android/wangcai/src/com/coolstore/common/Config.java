package com.coolstore.common;

public class Config {
	public enum EnvType {
		EnvType_Formal,
		EnvType_Dev
	}
	public static void Initlialize(EnvType enumEvnType) {
		m_enumEvnType = enumEvnType;
	}
	
	public static String GetLoginUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/register";
		}
		else {
			return "https://ssl.getwangcai.com/0/register";
		}
	}
	public static String GetLotteryUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/task/check-in";
		}
		else {
			return "https://ssl.getwangcai.com/0/task/check-in";
		}		
	}
	public static String GetSendCaptchaUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/bind_phone";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/bind_phone";			
		}
	}
	public static String GetResendCaptchaUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/sms/resend_sms_code";
		}
		else {
			return "https://ssl.getwangcai.com/0/sms/resend_sms_code";			
		}		
	}
	public static String GetVerifyCaptchaUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/bind_phone_confirm";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/bind_phone_confirm";			
		}		
	}
	public static String GetUserInfoUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/info";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/info";			
		}
		
	}
	public static String GetUpdateUserInfoUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/update_user_info";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/update_user_info";			
		}
	}
	public static String GetUpdateInviterUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/account/update_inviter";
		}
		else {
			return "https://ssl.getwangcai.com/0/account/update_inviter";			
		}
	}
	
	
	public static String GetExtractAlipayUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/order/alipay";
		}
		else {
			return "https://ssl.getwangcai.com/0/order/alipay";			
		}
	}
	
	public static String GetExtractPhoneBillUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/order/phone_pay";
		}
		else {
			return "https://ssl.getwangcai.com/0/order/phone_pay";			
		}
	}
	
	public static String GetExtractQbiUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/order/qb_pay";
		}
		else {
			return "https://ssl.getwangcai.com/0/order/qb_pay";			
		}
	}

	public static String GetExchageListUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/order/exchange_list";	
		}
		else {		
			return "https://ssl.getwangcai.com/0/order/exchange_list";
		}
	}


	public static String GetExchangeCodeUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/order/exchange_code";	
		}
		else {		
			return "https://ssl.getwangcai.com/0/order/exchange_code";
		}
	}
	
	public static String GetDownloadAppUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/task/download_app"; 
		}
		else {
			return "https://ssl.getwangcai.com/0/task/download_app";
		}		
	}
	public static String GetLiveUpdateUrl() {
		return "http://wangcai.meme-da.com/android_web/update.php?app=WangcaiAndroid";
	}
	public static String GetPollUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/task/poll";
		}
		else {
			return "https://ssl.getwangcai.com/0/task/poll";
		}
	}
	
	public static String GetShareTaskUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/task/share";
		}
		else {
			return "https://ssl.getwangcai.com/0/task/share";
		}
	}
	
	public static String GetInviteUrl() {
		return "http://invite.getwangcai.com/index.php?code=%s";				
	}
	

	public static String GetInviteTaskUrl() {
		return "http://www.getwangcai.com/?code=%s&name=wangcai";				
	}
	
	private final static String sg_strWebServiceUrl = "http://service.meme-da.com/index.php/mobile/shouce/view/h_id/";
	
	//邀请规则
	public static String GetInviteRuleUrl() {
		return sg_strWebServiceUrl + "123";
	}
	
	//积分墙规则
	public static String GetOfferWallRuleUrl() {
		return sg_strWebServiceUrl + "132";
	}

	//使用条款
	public static String GetLicenseUrl() {
		return sg_strWebServiceUrl + "128";
	}
	
	//客服帮助
	public static String GetHelpUrl() {
		return "http://service.meme-da.com/index.php/mobile/shouce/list/hc_id/76";
	}
	
	public static String GetOrderDetailUrl() {
		return "http://wangcai.meme-da.com/android_web/order_info.php";
	}
	
	// 交易明细
	public static String GetTransactionDetailUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "http://dev.meme-da.com/android_web/exchange_info2.php";
		}
		else {
			return "http://wangcai.meme-da.com/android_web/exchange_info2.php";
		}
	}
	public static String GetSurveyListUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/task/survey_list";
		}
		else {
			return "https://ssl.getwangcai.com/0/task/survey_list";
		}		
	}
	public static String GetSurveyUrl() {
		if (m_enumEvnType == EnvType.EnvType_Dev) {
			return "https://dev.getwangcai.com/0/task/survey";
		}
		else {
			return "https://ssl.getwangcai.com/0/task/survey";
		}		
	}

	public static String GetServiceCenterUrl() {
		return "http://service.meme-da.com/index.php/mobile/consulting";
	}
	//============================================================================================
	//====================================				积分墙				====================================
	//有米
	public static String sg_strYoumiAppId = "bc15bcaee2f5d263";
	public static String sg_strYoumiAppSecret = "6306937f74dd8f5f";
																//2ca43fa93e8cae3e
	
	//米迪
	public static String sg_strMidiPublishId = "18194";
	public static String sg_strMidiAppSecret = "l83il64am89r9y6b";
	
	
	//点乐
	public static String sg_strDianleAppId = "a903aa22facdfe9af70d7259791bbe92";
	
	//触控
	//1DA13AE6B85966B4172AB369B21610D3
	public static String sg_strPunchboxPlacementId = "818634143n6msqe";
	

	//============================================================================================
	public static String sg_strPushKeyName_NewAward = "NewAward";
	

	//============================================================================================
	
	private static EnvType m_enumEvnType = EnvType.EnvType_Formal;
}
