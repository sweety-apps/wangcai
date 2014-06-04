package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;

public class Request_ExtractAliPay extends Requester{


    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("alipay_account", m_strAliPayAccount);
			mapRequestInfo.put("amount", String.valueOf(m_nAmount));
			mapRequestInfo.put("discount", String.valueOf(m_nDiscount));
			m_requestInfo = Requester.NewPostRequestInfo(Config.GetExtractAlipayUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {

		m_strOrderId = Util.ReadJsonString(rootObject, "order_id");
    	return true;
    }
    
    public void SetAliPayAccount(String strAliPayAccount) {
    	m_strAliPayAccount = strAliPayAccount;
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
    

    private String m_strAliPayAccount;
    private int m_nAmount;
    private int m_nDiscount;
    
    private String m_strOrderId;

}