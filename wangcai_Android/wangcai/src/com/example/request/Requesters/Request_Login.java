package com.example.request.Requesters;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.example.common.Util;
import com.example.request.AppWallConfig;
import com.example.request.Config;
import com.example.request.ExtractInfo;
import com.example.request.RequestManager;
import com.example.request.Requester;
import com.example.request.TaskListInfo;
import com.example.request.UserInfo;
import com.example.wangcai.base.SystemInfo;


public class Request_Login extends Requester{	
	public Request_Login() {
	}

    @Override
	public Requester.RequestInfo GetRequestInfo() {
		if (m_requestInfo == null) {
			Map<String, String> mapRequestInfo = new HashMap<String, String>();
			mapRequestInfo.put("idfa", "3461AC00-92DC-5B5C-9464-7971F01F4963");
			mapRequestInfo.put("mac", SystemInfo.GetMacAddress());		
			mapRequestInfo.put("timestamp", String.valueOf(System.currentTimeMillis()));
			m_requestInfo = new Requester.RequestInfo(Config.GetLoginUrl(), "", mapRequestInfo);
		}
		return m_requestInfo;
	}
    

    @Override
	public boolean ParseResponse(JSONObject rootObject) {
		m_bNeedForceUpdate = (Util.ReadJsonInt(rootObject, "force_update") != 0);

		RequestManager requestManager = RequestManager.GetInstance();
		requestManager.SetSessionId(Util.ReadJsonString(rootObject, "session_id"));
		requestManager.SetDeviceId(Util.ReadJsonString(rootObject, "device_id"));
		requestManager.SetUserId(Util.ReadJsonInt(rootObject, "userid"));
		
		m_userInfo = ReadUserInfo(rootObject);
		m_extractInfo = ReadExtractInfo(rootObject);
		m_taskListInfo = ReadTaskListInfo(rootObject);
		m_appwalConfig = ParseAppwallConfig(rootObject);

    	return true;
	}
    
    //读用户信息
    private UserInfo ReadUserInfo(JSONObject rootObject) {
    	UserInfo userInfo = null;
    	try {
    		userInfo = new UserInfo();
			
			userInfo.SetNextLevel(Util.ReadJsonInt(rootObject, "exp_next_level"));
			userInfo.SetCanWithdrawal(Util.ReadJsonInt(rootObject, "no_withdraw") == 0);
			
			userInfo.SetShareIncome(Util.ReadJsonInt(rootObject, "shared_income"));
			
			userInfo.SetTotalOutgo(Util.ReadJsonInt(rootObject, "outgo"));
			
			userInfo.SetTotalIncome(Util.ReadJsonInt(rootObject, "income"));
			userInfo.SetRecentIncome(Util.ReadJsonInt(rootObject, "recent_income"));
			//Util.ReadJsonInt(rootObject, "in_review");
			m_nPollElapse = Util.ReadJsonInt(rootObject, "polling_interval");
			userInfo.SetOfferWallIncome(Util.ReadJsonInt(rootObject, "offerwall_income"));

			userInfo.SetUserId(Util.ReadJsonInt(rootObject, "userid"));
			userInfo.SetBalance(Util.ReadJsonInt(rootObject, "balance"));
			userInfo.SetCurrentLevel(Util.ReadJsonInt(rootObject, "level"));
			userInfo.SetNextLevelExperience(Util.ReadJsonInt(rootObject, "exp_next_level"));
			userInfo.SetCurrentExperience(Util.ReadJsonInt(rootObject, "exp_current"));
			userInfo.SetBenefit(Util.ReadJsonInt(rootObject, "benefit"));
			
			userInfo.SetInviteCode(Util.ReadJsonString(rootObject, "invite_code"));
			userInfo.SetInviter(Util.ReadJsonString(rootObject, "inviter"));
			
			userInfo.SetDeviceId(Util.ReadJsonString(rootObject, "device_id"));
			userInfo.SetPhoneNumber(Util.ReadJsonString(rootObject, "phone"));
    	}catch(Exception e) {
    		userInfo = null;
    	}
    	return userInfo;
    }
    //读提取现金的设置
    private ExtractInfo ReadExtractInfo(JSONObject rootObject) {
    	ExtractInfo extractInfo = new ExtractInfo();

		try {
			JSONArray jsonArray = rootObject.getJSONArray("withdraw_config");
		
			int nLength = jsonArray.length();
			for (int i = 0;  i < nLength; i++) {
				JSONObject itemObj = jsonArray.getJSONObject(i);

				int nType = Util.ReadJsonInt(itemObj, "type");
				ExtractInfo.ExtractType enumType = ExtractInfo.ExtractType.ExtractType_Phone;
				switch (nType) {
				case 1:
					enumType = ExtractInfo.ExtractType.ExtractType_Phone;
					break;
				case 2:
					enumType = ExtractInfo.ExtractType.ExtractType_AliPay;
					break;
				case 4:
					enumType = ExtractInfo.ExtractType.ExtractType_QBi;
					break;
				}
				ExtractInfo.ExtractItem extractItem = new ExtractInfo.ExtractItem(enumType);
				
				JSONArray subItemArray = itemObj.getJSONArray("info");
				int nSubItemCount = subItemArray.length();
				for (int j = 0; j < nSubItemCount; j++) {
					JSONObject subItemObj = subItemArray.getJSONObject(j);
					int nAmount = Util.ReadJsonInt(subItemObj, "amount");
					int nPrice = Util.ReadJsonInt(subItemObj, "price");
					int nHot = Util.ReadJsonInt(subItemObj, "hot");
					ExtractInfo.ExtractSubItem subItem = new ExtractInfo.ExtractSubItem(nAmount, nPrice, nHot != 0);
					extractItem.m_subItems.add(subItem);
				}
				extractInfo.AddItem(extractItem);
			}
		}catch(Exception e) {
			extractInfo = null;
		}
    	return extractInfo;
    }
    //读任务列表
    private TaskListInfo ReadTaskListInfo(JSONObject rootObject) {
    	TaskListInfo taskListInfo = new TaskListInfo();

		try {
			JSONArray jsonArray = rootObject.getJSONArray("task_list");
			int nLength = jsonArray.length();
			for (int i = 0;  i < nLength; i++) {
				JSONObject itemObj = jsonArray.getJSONObject(i);
				TaskListInfo.TaskInfo taskInfo = new TaskListInfo.TaskInfo();
				taskInfo.m_nTaskType = Util.ReadJsonInt(itemObj, "type");
				taskInfo.m_nTaskStatus = Util.ReadJsonInt(itemObj, "status");
				taskInfo.m_nId = Util.ReadJsonInt(itemObj, "id");
				taskInfo.m_nLevel = Util.ReadJsonInt(itemObj, "level");
				taskInfo.m_nMoney = Util.ReadJsonInt(itemObj, "money");				
				taskInfo.m_strTitle = Util.ReadJsonString(itemObj, "title");
				taskInfo.m_strDescription = Util.ReadJsonString(itemObj, "desc");
				taskInfo.m_strIntroduction = Util.ReadJsonString(itemObj, "intro");
				taskInfo.m_strIconUrl = Util.ReadJsonString(itemObj, "icon");
				taskInfo.m_strRedirctUrl = Util.ReadJsonString(itemObj, "rediect_url");
				taskListInfo.AddTaskInfo(taskInfo);
			}
		}catch (Exception e) {
			taskListInfo = null;
		}
		return taskListInfo;
    }
    private AppWallConfig ParseAppwallConfig(JSONObject rootObject) {
    	AppWallConfig appwallConfig = new AppWallConfig();
		try {
			JSONObject jsonObject = rootObject.getJSONObject("offerwall");
			appwallConfig.AddWall("mopan", Util.ReadJsonInt(jsonObject, "mopan"));
			appwallConfig.AddWall("jupeng", Util.ReadJsonInt(jsonObject, "jupeng"));
			appwallConfig.AddWall("miidi", Util.ReadJsonInt(jsonObject, "miidi"));
			appwallConfig.AddWall("domob", Util.ReadJsonInt(jsonObject, "domob"));
			appwallConfig.AddWall("punchbox", Util.ReadJsonInt(jsonObject, "punchbox"));
			appwallConfig.AddWall("mobsmar", Util.ReadJsonInt(jsonObject, "mobsmar"));
			appwallConfig.AddWall("limei", Util.ReadJsonInt(jsonObject, "limei"));
			appwallConfig.AddWall("youmi", Util.ReadJsonInt(jsonObject, "youmi"));
		} catch (JSONException e) {
			appwallConfig = null;
		}	
		return appwallConfig;
    }
    
    
    public UserInfo GetUserInfo() {
    	return m_userInfo;
    }
    public ExtractInfo GetExtractInfo() {
    	return m_extractInfo;
    }
    public TaskListInfo GetTaskListInfo() {
    	return m_taskListInfo;
    }
    public boolean GetNeedForceUpdate() {
    	return m_bNeedForceUpdate;
    }
    public AppWallConfig GetWallConfig() {
    	return m_appwalConfig;
    }
    public int GetPollElapse() {
    	return m_nPollElapse;
    }

    private int m_nPollElapse = 0;
    private boolean m_bNeedForceUpdate = false; 
	private UserInfo m_userInfo = null;
	private TaskListInfo m_taskListInfo = null;	
	private ExtractInfo m_extractInfo = null;
	private AppWallConfig m_appwalConfig = null;
}


