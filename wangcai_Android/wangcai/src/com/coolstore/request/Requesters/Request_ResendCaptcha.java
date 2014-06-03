package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Util;
import com.coolstore.request.Config;
import com.coolstore.request.Requester;

public class Request_ResendCaptcha extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("token", m_strOldToken);
			mapRequestInfo.put("code_length", "5");	//todo ����?
			
			m_requestInfo = Requester.NewPostRequestInfo(Config.GetResendCaptchaUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
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
