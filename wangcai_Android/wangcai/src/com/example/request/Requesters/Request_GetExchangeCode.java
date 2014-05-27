package com.example.request.Requesters;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.example.common.Util;
import com.example.request.Config;
import com.example.request.Requester;


public class Request_GetExchangeCode extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("exchange_type", String.valueOf(m_nExchangeType));
			
			m_requestInfo = new Requester.RequestInfo(Config.GetExtractQbiUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {

    	m_strExchangeCode = Util.ReadJsonString(rootObject, "exchange_code");
    	return true;
    }
    
    
    public void SetExchangeType(int nExchangeType) {
    	m_nExchangeType = nExchangeType;
    }
    public String GetExchangeCode() {
    	return m_strExchangeCode;
    }
    
    private int m_nExchangeType;
    private String m_strExchangeCode;
}


