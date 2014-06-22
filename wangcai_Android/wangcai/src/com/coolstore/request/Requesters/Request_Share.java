package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;

public class Request_Share extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			m_requestInfo = Requester.NewPostRequestInfo(Config.GetShareTaskUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		m_nIncome = Util.ReadJsonInt(rootObject, "income");
    	return true;
    }
    
    public int GetIncome() {
    	return m_nIncome;
    }
    
    
    private int m_nIncome = 0;
}




