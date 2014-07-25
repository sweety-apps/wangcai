package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;


public class Request_Lottery extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		super.InitPostRequestInfo(Config.GetLotteryUrl(), "", mapRequestInfo);
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
