package com.coolstore.request.Requesters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.coolstore.common.Config;
import com.coolstore.common.SystemInfo;
import com.coolstore.common.Util;
import com.coolstore.request.OfferWallManager;
import com.coolstore.request.ExtractInfo;
import com.coolstore.request.OfferWalls;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.TaskListInfo;
import com.coolstore.request.UserInfo;


public class Request_Login extends Requester{	
	public Request_Login() {
	}

    @Override
	protected void InitRequestInfo() {	
		Map<String, String> mapRequestInfo = new LinkedHashMap<String, String>();
		mapRequestInfo.put("imei", SystemInfo.GetImei());
		mapRequestInfo.put("serial", SystemInfo.GetSerial());
		mapRequestInfo.put("phone", SystemInfo.GetPhoneNumber());
		mapRequestInfo.put("android_id", SystemInfo.GetAndroidId());
		mapRequestInfo.put("mac", SystemInfo.GetMacAddress());		
		mapRequestInfo.put("sign", m_strSign);		
		mapRequestInfo.put("timestamp", String.valueOf(System.currentTimeMillis()));
		super.InitPostRequestInfo(Config.GetLoginUrl(), "", mapRequestInfo);
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
		m_appwalConfig = ParseOfferwallConfig(rootObject);

    	return true;
	}
    
    @Override
	public void Initialize() {
    	super.Initialize();
    	
		String strPostData = GetPostData();
		
		String strSha1 = Util.GetSha1(strPostData + "c4c6ac66-3d86-4692-bf5c-78fc4c3df1a0");
		AddData("sig", strSha1.substring(2, 2 + 32));
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
			

			Log.i("PollIncome", String.format("Login----OfferWallInfo(%d)", userInfo.GetOfferWallIncome()));

			userInfo.SetSessionId(Util.ReadJsonString(rootObject, "session_id"));
			userInfo.SetDeviceId(Util.ReadJsonString(rootObject, "device_id"));
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
			m_strTipsString = Util.ReadJsonString(rootObject, "tips");
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
    private static class WallInfo {
    	public WallInfo(String strName, int nStatus) {
    		m_strName = strName;
    		m_nStatus = nStatus;
    	}
    	public String m_strName;
    	public int m_nStatus;
    }
    private OfferWallManager ParseOfferwallConfig(JSONObject rootObject) {
    	OfferWallManager offerWallConfig = new OfferWallManager();
		try {
			ArrayList<WallInfo> listWallInfo = new ArrayList<WallInfo>();
			JSONObject jsonObject = rootObject.getJSONObject("offerwall");
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strMopan);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strJupeng);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strMiidi);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strDomob);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strPunchbox);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strMobsmar);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strLimei);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strMopan);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strYoumi);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strAnwo);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strWanpu);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strWinAds);
			ReadOfferWall(listWallInfo, jsonObject, OfferWalls.sg_strDianLe);

			try {
				//读顺序, 并按顺序加进去
				JSONArray jsonArray = jsonObject.getJSONArray("__sort");
				int nCount = 0;
				if (jsonArray != null) {
					nCount = jsonArray.length();
				}
				for (int i = 0;  i < nCount; ++i) {
					String strName = jsonArray.getString(i);
					WallInfo wallInfo = FindAndRemove(listWallInfo, strName);	//查找并删除
					if (wallInfo != null) {
						offerWallConfig.AddWall(wallInfo.m_strName, wallInfo.m_nStatus);
					}
				}
			} catch (JSONException e) {	}	
			//把剩下的加进去
			for (WallInfo wallInfo : listWallInfo) {
				offerWallConfig.AddWall(wallInfo.m_strName, wallInfo.m_nStatus);				
			}
		} catch (JSONException e) {
			offerWallConfig = null;
		}	
		return offerWallConfig;
    }
    private WallInfo FindAndRemove(ArrayList<WallInfo> listWallInfo, final String strName) {
    	int nCount = listWallInfo.size();
    	for (int i = 0; i < nCount; i++) {
    		WallInfo wallInfo = listWallInfo.get(i);
    		if (strName.equals(wallInfo.m_strName)) {
    			listWallInfo.remove(i);
    			return wallInfo;
    		}
    	}
    	return null;
    }

    private void ReadOfferWall(ArrayList<WallInfo> listWallInfo, JSONObject obj, String strName) {
    	int nStatus = Util.ReadJsonInt(obj, strName, -1);
    	if (nStatus < 0) {
    		return;
    	}
    	listWallInfo.add(new WallInfo(strName, nStatus));
    }
    

    public void SetSign(String strSign) {
    	m_strSign = strSign;
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
    public OfferWallManager GetWallConfig() {
    	return m_appwalConfig;
    }
    public int GetPollElapse() {
    	return m_nPollElapse;
    }
    public String GetTipString() {
    	return m_strTipsString;
    }

    private String m_strSign;
    private int m_nPollElapse = 0;
    private boolean m_bNeedForceUpdate = false; 
	private UserInfo m_userInfo = null;
	private TaskListInfo m_taskListInfo = null;	
	private ExtractInfo m_extractInfo = null;
	private OfferWallManager m_appwalConfig = null;
	private String m_strTipsString = null;
}


