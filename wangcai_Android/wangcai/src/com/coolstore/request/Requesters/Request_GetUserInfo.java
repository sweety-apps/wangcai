package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Util;
import com.coolstore.request.Config;
import com.coolstore.request.Requester;

public class Request_GetUserInfo extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			
			m_requestInfo = Requester.NewPostRequestInfo(Config.GetUserInfoUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		
		m_nAge = Util.ReadJsonInt(rootObject, "age");
		m_nSex = Util.ReadJsonInt(rootObject, "interest");
		m_strInterest = Util.ReadJsonString(rootObject, "interest");

    	return true;
    }
    public int GetAge() {
    	return m_nAge;
    }
    public int GetSex(){
    	return m_nSex;
    }
    public String GetInterest() {
    	return m_strInterest;
    }

    private int m_nAge;
    private int m_nSex;
    private String m_strInterest;
}