package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;

public class Request_ResendCaptcha extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("token", m_strOldToken);
		mapRequestInfo.put("code_length", "5");	//todo втвх?
		
		super.InitPostRequestInfo(Config.GetResendCaptchaUrl(), "", mapRequestInfo);
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		m_strNewToken = Util.ReadJsonString(rootObject, "token");
    	return true;
    }

    public void SetOldToken(String strToken) {
    	m_strOldToken = strToken;
    }
    public String GetNewToken() {
    	return m_strNewToken;
    }
    
    private String m_strOldToken;
    private String m_strNewToken;
}
