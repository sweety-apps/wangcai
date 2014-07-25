package com.coolstore.request.Requesters;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.request.Requester;

public class Request_Survey extends Requester{
    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("id", String.valueOf(m_nSurveyId));
		mapRequestInfo.put("survey", m_strSurveyData);
		super.InitPostRequestInfo(Config.GetSurveyUrl(), "", mapRequestInfo);
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
    	return true;
    }
	

    public void SetSurveyId(int nId) {
    	m_nSurveyId = nId;
    }
    
    public void SetSurveyData(String strSurveyData) {
    	m_strSurveyData = strSurveyData;
    }
    
    private int m_nSurveyId;
    private String m_strSurveyData;
}
