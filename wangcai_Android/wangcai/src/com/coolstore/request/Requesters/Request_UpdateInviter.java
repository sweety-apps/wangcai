package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.request.Requester;

public class Request_UpdateInviter extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("inviter", m_strInviter);
		super.InitPostRequestInfo(Config.GetUpdateInviterUrl(), "", mapRequestInfo);
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