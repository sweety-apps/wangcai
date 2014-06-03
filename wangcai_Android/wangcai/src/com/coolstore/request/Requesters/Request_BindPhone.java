package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Util;
import com.coolstore.request.Config;
import com.coolstore.request.Requester;


public class Request_BindPhone extends Requester{

	public void SetPhoneNumber(String strPhoneNumber) {
		m_strPhoneNumber = strPhoneNumber; 
	}
    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("phone", m_strPhoneNumber);
			m_requestInfo = Requester.NewPostRequestInfo(Config.GetSendCaptchaUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		
		m_strToken = Util.ReadJsonString(rootObject, "token");
    	return true;
    }
    public String GetToken() {
    	return m_strToken;
    }
    
    private String m_strPhoneNumber;
    private String m_strToken;
}
