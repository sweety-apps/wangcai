package com.example.wangcai;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Iterator;

import com.example.common.BuildSetting;
import com.example.common.TimerManager;
import com.example.common.TimerManager.TimerManagerCallback;
import com.example.request.AppWallConfig;
import com.example.request.Config;
import com.example.request.ExtractInfo;
import com.example.request.RequestManager;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.TaskListInfo;
import com.example.request.UserInfo;
import com.example.request.Requesters.Request_Login;
import com.example.request.Requesters.Request_Poll;
import com.example.wangcai.base.SystemInfo;

import android.content.Context;
import android.telephony.TelephonyManager;

public class WangcaiApp implements RequestManager.IRequestManagerCallback, TimerManager.TimerManagerCallback{
	public interface WangcaiAppEvent {
		void OnLoginComplete(int nResult, String strMsg);
		void OnUserInfoUpdate();
		void OnBalanceUpdate(int nCurrentBalance, int nNewBalance);
		//void OnLevelChanged();
		void OnGetAppAward(int nAward);
		void OnLevelUpgrate(int nLevelChanged);
	}
	public class TaskInfo {
		public int m_nId;
		public int m_nType;
		public String m_strTitle;
		public String m_strHintText;
		public String m_strIcon;
		public boolean m_bComplete;
		public int m_nMoney;
	}

	private static WangcaiApp m_sWangcaiApp = new WangcaiApp();
	public static WangcaiApp GetInstance() {
		return m_sWangcaiApp;
	}

	public void Initialize(Context context) {
		m_AppContext =  context;
		
		SystemInfo.Initialize(context);
		
		ConfigCenter.GetInstance().Initialize(context);
		RequestManager.GetInstance().Initialize(context.getResources().openRawResource(R.raw.cert));
	}

	public boolean NeedForceUpdate() {
		return m_bNeedForceUpdate;
	}
	
	public int GetTaskCount() {
		return m_listTaskInfos.size();
	}
	TaskInfo GetTaskInfo(int nIndex){
		if (nIndex < 0 || nIndex >= m_listTaskInfos.size()) {
			return null;
		}
		return m_listTaskInfos.get(nIndex);
	}
	
	public boolean HasLogin() {
		return m_bHasLogin;
	}
	public void ChangeBalance(int nDiff) {
		int nCurrentBalance = m_userInfo.GetBalance();
		int nNewBalance = nCurrentBalance + nDiff;
		m_userInfo.SetBalance(nNewBalance);

		ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
		for (WeakReference<WangcaiAppEvent> weakPtr: listEventLinsteners) {
			WangcaiAppEvent eventLinstener = weakPtr.get();
			eventLinstener.OnBalanceUpdate(nCurrentBalance, nNewBalance);
		}
	}
	private boolean test_show = false;
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_Login) {
			int nResult = req.GetResult();
			if (nResult == 0){
				Request_Login loginRequester = (Request_Login)req;
				m_bNeedForceUpdate = loginRequester.GetNeedForceUpdate();
				m_strHintMsg = loginRequester.GetMsg();
				m_userInfo = loginRequester.GetUserInfo();
				m_extractInfo = loginRequester.GetExtractInfo();
				m_taskListInfo = loginRequester.GetTaskListInfo();
				m_appWallConfig = loginRequester.GetWallConfig();
				m_nPollElapse = loginRequester.GetPollElapse();

				if (m_nPollTimerId == 0) {
					m_nPollTimerId = TimerManager.GetInstance().StartTimer(GetPollElapse() * 1000, this);
				}
			}
			
			ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
			for (WeakReference<WangcaiAppEvent> weakPtr: listEventLinsteners) {
				WangcaiAppEvent eventLinstener = weakPtr.get();
				eventLinstener.OnLoginComplete(nResult, req.GetMsg());
			}
			
		}
		else if (req instanceof Request_Poll) {
			Request_Poll detailReq = (Request_Poll)req;
			if (BuildSetting.sg_bIsDebug && !test_show) {
				test_show = true;
				ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners1 = GetEventListClone();
				for (WeakReference<WangcaiAppEvent> weakPtr:listEventLinsteners1) {
					WangcaiAppEvent eventLinstener = weakPtr.get();
					eventLinstener.OnGetAppAward(123);
				}
			}
			if (req.GetResult() == 0) {
				boolean bIsNewMsg = detailReq.IsNewMsg();
				if (bIsNewMsg) {
					//新消息todo
				}

				int nLevelChange = 0;
				int nCurrentLevel = detailReq.GetCurrentLevel();
				if (nCurrentLevel > 0) {
					if (m_userInfo.GetCurrentLevel() < nCurrentLevel) {
						nLevelChange = nCurrentLevel - m_userInfo.GetCurrentLevel();
					}
					m_userInfo.SetCurrentLevel(nCurrentLevel);
					m_userInfo.SetCurrentExperience(detailReq.GetCurrentExperience());
					m_userInfo.SetNextLevelExperience(detailReq.GetNextLevelExperience());
					
					int nBenefit = detailReq.GetBenefit();
					if (nBenefit > 0) {
						m_userInfo.SetBenefit(nBenefit);
					}
					//todo 升级提示
				}
				int nWangcaiIncome = 0;
				int nTaskCount = detailReq.GetTaskCount();
				for (int i = 0; i < nTaskCount; ++i) {
					Request_Poll.TaskInfo taskInfo = detailReq.GetTaskInfo(i);
					if (!m_taskListInfo.IsComplete(taskInfo.m_nTaskId)) {
						nWangcaiIncome += taskInfo.m_nIncome;
					}
				}

				int nOfferWallIncome = detailReq.GetOfferWallIncome();
				int nPreOfferWallIncome = m_userInfo.GetOfferWallIncome();
				if (nOfferWallIncome > nPreOfferWallIncome || nWangcaiIncome > 0) {
					m_userInfo.SetOfferWallIncome(nOfferWallIncome);

					int nNewOfferWallIncome = nOfferWallIncome - nPreOfferWallIncome;
					int nNewIncome = nNewOfferWallIncome + nWangcaiIncome; 
					if (nNewIncome > 0) {
						ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
						for (WeakReference<WangcaiAppEvent> weakPtr:listEventLinsteners) {
							WangcaiAppEvent eventLinstener = weakPtr.get();
							eventLinstener.OnGetAppAward(nNewIncome);
						}
						if (nWangcaiIncome > 0) {
							Login();		//登陆刷新列表
						}
						ChangeBalance(nNewIncome);
					}
				}
			}
		}
	}

	public void OnTimer(int nId, int nHitTimes) {
		if (nId == m_nPollTimerId) {
			if (IsForceGround()) {
				Request_Poll req = (Request_Poll)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Poll);
				RequestManager.GetInstance().SendRequest(req, false, this);
			}
		}
	}
	
	//登陆
	public boolean Login() {
		RequestManager requestManager = RequestManager.GetInstance();
		Request_Login request = (Request_Login)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Login);
		requestManager.SendRequest(request, true, this);
		return true;
	}
	public Context GetContext() {
		return m_AppContext;
	}
	public void AddEventLinstener(WangcaiAppEvent eventLinstener) {
		int nCount = m_listEventLinsteners.size();
		for (int i = 0; i < nCount; ++i) {
			if (m_listEventLinsteners.get(i).get() == eventLinstener) {
				return;
			}
		}
		m_listEventLinsteners.add(new WeakReference<WangcaiAppEvent>(eventLinstener));
	}
	public void RemoveEventLinstener(WangcaiAppEvent eventLinstener) {
		int nCount = m_listEventLinsteners.size();
		for (int i = 0; i < nCount; ++i) {
			if (m_listEventLinsteners.get(i).get() == eventLinstener) {
				m_listEventLinsteners.remove(i);
				break;
			}
		}
	}
	public String GetPhoneId() {
		if (m_strPhoneId == null) {
			TelephonyManager TelephonyMgr = (TelephonyManager)m_AppContext.getSystemService(Context.TELEPHONY_SERVICE); 
			m_strPhoneId = TelephonyMgr.getDeviceId(); 
		}
		return m_strPhoneId;
	}
	public String GetHintMsg() {
		return m_strHintMsg;
	}
	public void UpdateUserInfo(UserInfo  userInfo) {
		m_userInfo = userInfo;
		
		ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
		for (WeakReference<WangcaiAppEvent> weakPtr:listEventLinsteners) {
			WangcaiAppEvent eventLinstener = weakPtr.get();
			eventLinstener.OnUserInfoUpdate();
		}		
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
    public AppWallConfig GetAppWallConfig() {
    	return m_appWallConfig; 
    }
    public int GetPollElapse() {
    	return m_nPollElapse;
    }
    public boolean IsForceGround() {
    	return m_bForceGround;
    }
    public void SetForceGround(boolean bForceGround) {
    	m_bForceGround = bForceGround;
    }
    private ArrayList<WeakReference<WangcaiAppEvent>>  GetEventListClone() {
    	ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = new ArrayList<WeakReference<WangcaiAppEvent>>(); 
    	Iterator<WeakReference<WangcaiAppEvent>> sListIterator = m_listEventLinsteners.iterator();  
    	while(sListIterator.hasNext()){  
    		WeakReference<WangcaiAppEvent> weakPtr = sListIterator.next();  
    	    if(weakPtr.get() == null){  
    	    	sListIterator.remove();  
    	    }  
    	    else {
    	    	listEventLinsteners.add(weakPtr);
    	    }
    	}
    	return listEventLinsteners;
    }
    
	private UserInfo m_userInfo = null;
	private TaskListInfo m_taskListInfo = null;	
	private ExtractInfo m_extractInfo = null;

	private String m_strHintMsg;
	private String m_strPhoneId;	
	private boolean m_bNeedForceUpdate = false;
	private boolean m_bHasLogin;
	private ArrayList<TaskInfo> m_listTaskInfos;
	private AppWallConfig m_appWallConfig;
	
	private int m_nPollElapse;		
	private Context m_AppContext;
	private boolean m_bForceGround = false;;
	private int m_nPollTimerId = 0;

	
	private ArrayList<WeakReference<WangcaiAppEvent>> m_listEventLinsteners = new ArrayList<WeakReference<WangcaiAppEvent>>();
}
