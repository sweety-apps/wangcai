package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.request.Config;
import com.coolstore.request.Requester;

public class Request_Share extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("appid", m_strAppId);
			m_requestInfo = Requester.NewPostRequestInfo(Config.GetShareTaskUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		
    	return true;
    }
    
    
    private String m_strAppId;
}




