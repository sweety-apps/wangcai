package com.coolstore.request.Requesters;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.common.Config;
import com.coolstore.common.SLog;
import com.coolstore.common.Util;
import com.coolstore.request.Requester;

public class Request_Poll extends Requester{

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new HashMap<String, String>();
		mapRequestInfo.put("msgid", String.valueOf(m_nMsgId));
		super.InitGetRequestInfo(Config.GetPollUrl(), "");
	}

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		
    	m_nOfferWallIncome = Util.ReadJsonInt(rootObject, "offerwall_income");

		SLog.i("PollIncome", String.format("POLL----OfferWallInfo(%d)", m_nOfferWallIncome));
    	m_nCurrentLevel = Util.ReadJsonInt(rootObject, "level");
    	m_nCurrentExperience = Util.ReadJsonInt(rootObject, "exp_current");
    	m_nNextLevelExperience = Util.ReadJsonInt(rootObject, "exp_next_level");
    	m_nBenefit = Util.ReadJsonInt(rootObject, "benefit");
    	m_bNewMsg = Util.ReadJsonBool(rootObject, "new_msg");

    	try {
			JSONArray incomeJsonArray = rootObject.getJSONArray("wangcai_income");
			int nCount = incomeJsonArray.length();
			for (int i = 0; i < nCount; ++i) {
				JSONObject itemJson = incomeJsonArray.getJSONObject(i);
				int nTaskId = Util.ReadJsonInt(itemJson, "task_id");
				//todo
				//ÅÐ¶Ïif (UnComplete nTaskId)
				int nIncome = Util.ReadJsonInt(itemJson, "income");
				m_listTaskInfo.add(new TaskInfo(nTaskId, nIncome));
			}
		} catch (JSONException e) {
		}
    	return true;
    }
    public static class TaskInfo {
    	public TaskInfo(int nTaskId, int nIncome) {
    		m_nTaskId = nTaskId;
    		m_nIncome = nIncome;
    	}
    	public int m_nTaskId;
    	public int m_nIncome;
    }
    public int GetTaskCount() {
    	return m_listTaskInfo.size();
    }
    public TaskInfo GetTaskInfo(int nIndex) {
    	if (nIndex < 0 || nIndex >= m_listTaskInfo.size()) {
    		return null;
    	}
    	return m_listTaskInfo.get(nIndex);
    }
    public void SetMsgId(int nMsgId) {
    	m_nMsgId = nMsgId;
    }
    public int GetOfferWallIncome() {
    	return m_nOfferWallIncome;
    }
    public int GetCurrentLevel() {
    	return m_nCurrentLevel;
    }
    public int GetCurrentExperience() {
    	return m_nCurrentExperience;
    } 
    public int GetNextLevelExperience() {
    	return m_nNextLevelExperience;
    }
    public int GetBenefit() {
    	return m_nBenefit;
    }
    public boolean IsNewMsg() {
    	return m_bNewMsg;
    }


    private int m_nMsgId = 0;
    private int m_nOfferWallIncome = 0;
    private int m_nCurrentLevel = 0;
    private int m_nCurrentExperience = 0;
    private int m_nNextLevelExperience = 0;
    private int m_nBenefit = 0;
    private ArrayList<TaskInfo> m_listTaskInfo = new ArrayList<TaskInfo>();
    private boolean m_bNewMsg = false;
}