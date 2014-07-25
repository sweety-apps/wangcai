package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.ExchangeListInfo;
import com.coolstore.request.Requester;

public class Request_GetExchangeList extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("stamp", m_strTimestamp);
		mapRequestInfo.put("ver", m_strVersion);
		mapRequestInfo.put("app", m_strAppName);
		super.InitGetRequestInfo(Config.GetExchageListUrl(), "", mapRequestInfo);
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
    	try {
    		m_exchangeInfo = new ExchangeListInfo();
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
    public ExchangeListInfo GetExchangeInfo() {
    	return m_exchangeInfo;
    }
    public void SetTimeStamp(String strTimeStamp) {
    	m_strTimestamp = strTimeStamp;
    }
    public void SetVersion(String strVersion) {
    	m_strVersion = strVersion;
    }
    public void SetAppName(String strAppName) {
    	m_strAppName = strAppName;
    }
    
    private String m_strTimestamp;
    private String m_strVersion;
    private String m_strAppName;
    private ExchangeListInfo m_exchangeInfo;
}
