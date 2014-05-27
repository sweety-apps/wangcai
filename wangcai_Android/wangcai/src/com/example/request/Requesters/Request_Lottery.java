package com.example.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.example.common.Util;
import com.example.request.Config;
import com.example.request.Requester;


public class Request_Lottery extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			m_requestInfo = new Requester.RequestInfo(Config.GetLotteryUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		m_nBonus = Util.ReadJsonInt(rootObject, "award");
    	return true;
    }
    public int GetBouns() {
    	return m_nBonus;
    }
    
    private int m_nBonus;
}
