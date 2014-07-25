package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;

public class Request_VerifyCaptcha  extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("token", m_strToken);
		mapRequestInfo.put("sms_code", m_strCaptcha);
		super.InitPostRequestInfo(Config.GetVerifyCaptchaUrl(), "", mapRequestInfo);
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {

		m_nUserId = Util.ReadJsonInt(rootObject, "userid");
		m_strInviteCode = Util.ReadJsonString(rootObject, "invite_code");
		m_strInviter = Util.ReadJsonString(rootObject, "inviter");
		m_nBalance = Util.ReadJsonInt(rootObject, "balance");
		m_nIncome = Util.ReadJsonInt(rootObject, "income");
		m_Outgo = Util.ReadJsonInt(rootObject, "outgo");
		m_nShareIncome = Util.ReadJsonInt(rootObject, "shared_income");
		m_nBindDeviceCount = Util.ReadJsonInt(rootObject, "total_device");
    	return true;
    }
    public void SetToken(String strToken) {
    	m_strToken = strToken;
    }
    public void SetCaptcha(String strCaptcha) {
    	m_strCaptcha = strCaptcha;
    }
    
    public int GetUserId() {
    	return m_nUserId;
    }
    public String GetInviteCode() {
    	return m_strInviteCode;
    }
    public String GetInviter() {
    	return m_strInviter;
    }
    public int GetBalance() {
    	return m_nBalance;
    }
    public int GetIncome() {
    	return m_nIncome;
    }
    public int GetOutgo() {
    	return m_Outgo;
    }
    public int GetShareIncome() {
    	return m_nShareIncome;
    }
    public int GetBindDeviceCount() {
    	return m_nBindDeviceCount;
    }
    
    private String m_strToken;
    private String m_strCaptcha;
    
    private int m_nUserId = 0;
    private String m_strInviteCode;
    private String m_strInviter;
    private int m_nBalance;
    private int m_nIncome;
    private int m_Outgo;
    private int m_nShareIncome;
    private int m_nBindDeviceCount;
}
