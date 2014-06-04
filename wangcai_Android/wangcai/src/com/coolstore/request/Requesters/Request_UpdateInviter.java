package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.request.Requester;

public class Request_UpdateInviter extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("inviter", m_strInviter);
			m_requestInfo = Requester.NewPostRequestInfo(Config.GetUpdateInviterUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
    	return true;
    }
    public void SetInviter(String strInviter) {
    	m_strInviter = strInviter;
    }
    
    private String m_strInviter;
}