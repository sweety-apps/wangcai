package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;

public class Request_Share extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		super.InitPostRequestInfo(Config.GetShareTaskUrl(), "", mapRequestInfo);
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




