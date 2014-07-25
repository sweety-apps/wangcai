package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;

public class Request_ExtractQBi extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("qq", m_strQQNumber);
		mapRequestInfo.put("amount", String.valueOf(m_nAmount));
		mapRequestInfo.put("discount", String.valueOf(m_nDiscount));
		mapRequestInfo.put("price", String.valueOf(m_nDiscount));
		
		super.InitPostRequestInfo(Config.GetExtractQbiUrl(), "", mapRequestInfo);
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
