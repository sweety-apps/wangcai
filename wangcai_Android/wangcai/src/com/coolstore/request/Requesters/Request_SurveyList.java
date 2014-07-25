package com.coolstore.request.Requesters;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;
import com.coolstore.request.SurveyInfo;

public class Request_SurveyList extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("stamp", String.valueOf(System.currentTimeMillis()));
		mapRequestInfo.put("ver", m_strVersion);
		mapRequestInfo.put("app", m_strAppName);
		super.InitGetRequestInfo(Config.GetSurveyListUrl(), "", mapRequestInfo);
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		try {
			JSONArray listJson = rootObject.getJSONArray("survey_list");
			int nCount = listJson.length();
			for (int i = 0; i < nCount; ++i) {
				JSONObject obj = listJson.getJSONObject(i);
				SurveyInfo info = new SurveyInfo();
				info.m_nId = Util.ReadJsonInt(obj, "id");
				info.m_strTitle = Util.ReadJsonString(obj, "title");
				info.m_strUrl = Util.ReadJsonString(obj, "url");
				info.m_nStatus = Util.ReadJsonInt(obj, "status");
				info.m_nMoney = Util.ReadJsonInt(obj, "money");
				info.m_nLevel = Util.ReadJsonInt(obj, "level");
				info.m_strIntroduction = Util.ReadJsonString(obj, "intro");
		      
				m_listSurveyInfo.add(info);
			}
		} catch (JSONException e) {
		}
    	return true;
    }
	
	public void SetAppName(String strAppName) {
		m_strAppName = strAppName;
	}
	public void SetVersion(String strVersion) {
		m_strVersion = strVersion;
	}
	public ArrayList<SurveyInfo> GetSurveyInfoList() {
		return m_listSurveyInfo;
	}
	
	private String m_strAppName;
	private String m_strVersion;
	private ArrayList<SurveyInfo> m_listSurveyInfo = new ArrayList<SurveyInfo>();
}
