package com.example.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.example.common.Util;
import com.example.request.Config;
import com.example.request.Requester;

public class Request_ExtractQBi extends Requester{

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("qq", m_strQQNumber);
			mapRequestInfo.put("amount", String.valueOf(m_nAmount));
			mapRequestInfo.put("discount", String.valueOf(m_nDiscount));
			mapRequestInfo.put("price", String.valueOf(m_nDiscount));
			
			m_requestInfo = new Requester.RequestInfo(Config.GetExtractQbiUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {

		m_strOrderId = Util.ReadJsonString(rootObject, "order_id");
    	return true;
    }
    
    public void SetQQNumber(String strQQNumber) {
    	m_strQQNumber = strQQNumber;
    }
    public void SetAmount(int nAmount) {
    	m_nAmount = nAmount;
    }
    public void SetDiscount(int nDiscount) {
    	m_nDiscount = nDiscount;
    }
    public String GetOrderId() {
    	return m_strOrderId;
    }
    

    private String m_strQQNumber;
    private int m_nAmount;
    private int m_nDiscount;
    
    private String m_strOrderId;
}
