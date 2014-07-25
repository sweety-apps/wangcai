package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;

public class Request_GetUserInfo extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		
		super.InitPostRequestInfo(Config.GetUserInfoUrl(), "", mapRequestInfo);
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