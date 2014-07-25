package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.request.Requester;

public class Request_UpdateUserInfo extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("age", String.valueOf(m_nAge));
		mapRequestInfo.put("sex", String.valueOf(m_nSex));
		mapRequestInfo.put("interest", m_strInterest);
		super.InitPostRequestInfo(Config.GetUpdateUserInfoUrl(), "", mapRequestInfo);
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
    	return true;
    }

    public void SetAge(int nAge) {
    	m_nAge = nAge;
    }
    public void SetSex(int nSex){
    	m_nSex = nSex;
    }
    public void SetInterest(String strInterest) {
    	m_strInterest = strInterest;
    }

    private int m_nAge;
    private int m_nSex;
    private String m_strInterest;
}
