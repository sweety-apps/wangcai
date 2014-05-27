package com.example.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.example.common.Util;
import com.example.request.Config;
import com.example.request.ExchangeInfo;
import com.example.request.Requester;

public class Request_GetExchangeList extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			
			m_requestInfo = new Requester.RequestInfo(Config.GetExchageListUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
    	try {
    		m_exchangeInfo = new ExchangeInfo();
			JSONArray jsonArray = rootObject.getJSONArray("exchange_list");
			int nListSize = jsonArray.length();
			for (int i = 0; i < nListSize; ++i) {
				JSONObject exchangeObj = jsonArray.getJSONObject(i);
				
				String strName = Util.ReadJsonString(exchangeObj, "name");
				int nType = Util.ReadJsonInt(exchangeObj, "type");
				String strIcon = Util.ReadJsonString(exchangeObj, "icon");
				int nPrice = Util.ReadJsonInt(exchangeObj, "price");
				int nRemainCount = Util.ReadJsonInt(exchangeObj, "remain");
				
				m_exchangeInfo.AddExchangeItem(strName, nType, strIcon, nPrice, nRemainCount);
			}
		} catch (JSONException e) {
			return false;
		}
    	return true;
    }
    public ExchangeInfo GetExchangeInfo() {
    	return m_exchangeInfo;
    }
    
    ExchangeInfo m_exchangeInfo;
}
