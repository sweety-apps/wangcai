package com.coolstore.wangcai;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Locale;

import cn.jpush.android.api.JPushInterface;
import cn.sharesdk.framework.ShareSDK;
import cn.waps.AppConnect;

import com.coolstore.common.BuildSetting;
import com.coolstore.common.Config;
import com.coolstore.common.LogUtil;
import com.coolstore.common.SLog;
import com.coolstore.common.SystemInfo;
import com.coolstore.common.TimerManager;
import com.coolstore.common.Util;
import com.coolstore.request.OfferWallManager;
import com.coolstore.request.ExchangeListInfo;
import com.coolstore.request.ExtractInfo;
import com.coolstore.request.RequestManager;
import com.coolstore.request.RequestManager.IRequestManagerCallback;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.SurveyInfo;
import com.coolstore.request.TaskListInfo;
import com.coolstore.request.UserInfo;
import com.coolstore.request.Requesters.Request_GetExchangeList;
import com.coolstore.request.Requesters.Request_Login;
import com.coolstore.request.Requesters.Request_Poll;
import com.coolstore.request.Requesters.Request_SurveyList;

import android.content.Context;
import android.media.AudioManager;
import android.media.SoundPool;
import android.telephony.TelephonyManager;

public class WangcaiApp implements 
									RequestManager.IRequestManagerCallback, 
									RequestManager.IRequestManagerEvent,
									TimerManager.TimerManagerCallback{
	public interface WangcaiAppEvent {
		void OnLoginComplete(boolean bFirstComplete, int nResult, String strMsg);
		void OnUserInfoUpdate();
		void OnBalanceUpdate(int nCurrentBalance, int nNewBalance);
		void OnLevelChanged(int nLevel, int nLevelChange);
		boolean OnGetAppAward(int nAward);
		void OnLevelUpgrate(int nLevelChanged);
		void OnSurveyRequestComplete(int nVersion, int nResult, String strMsg);
		void OnExchangeListRequestComplete(int nVersion, int nResult, String strMsg);
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
	public boolean HasInit() {
		return m_bInited;
	}

	public void Initialize(Context context) {
		if (m_bInited) {
			return;
		}
		m_bInited  = true;
        if (BuildSetting.sg_bUseFormatServer) {
        	Config.Initlialize(Config.EnvType.EnvType_Formal);
        }
        else {
        	Config.Initlialize(Config.EnvType.EnvType_Dev);
        }
        
		//日志
		SLog.setPath(ConfigCenter.GetInstance().GetCachePath() +  "/log","log","log");
		if (LogUtil.sg_bLogToFile) {
			SLog.setPolicy(SLog.LOG_ALL_TO_FILE);
		}
		else {
			SLog.setPolicy(SLog.LOG_ERROR_TO_FILE);
		}
		
		m_AppContext =  context;
		
		//系统信息
		SystemInfo.Initialize(context);
		
		//设置中心
		ConfigCenter.GetInstance().Initialize(context);
		
		//请求管理器
		RequestManager.GetInstance().Initialize(context.getResources().openRawResource(R.raw.cert));
				
		LogUtil.LogWangcai("Imei(%s) Serial(%s)  androidId(%s)  Mac(%s)", SystemInfo.GetImei(), SystemInfo.GetSerial(), SystemInfo.GetAndroidId(), SystemInfo.GetMacAddress());
	
		
	}

	public void Init3rdSdk(Context context) {
		m_AppContext = context;
    	ShareSDK.initSDK(m_AppContext);

		//万普
		AppConnect.getInstance("a506304b84012e95edada70ccfcc7044", "default", m_AppContext);
	}
	private void OnFirstLogin() {
		String strDeviceId = m_userInfo.GetDeviceId();

		//极光推送
		JPushInterface.setAlias(m_AppContext, strDeviceId, null);
        JPushInterface.setDebugMode(BuildSetting.sg_bIsDebug);
		JPushInterface.init(m_AppContext);
		if (!ConfigCenter.GetInstance().ShouldReceivePush()) {
			JPushInterface.stopPush(m_AppContext);
		}
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

		//保存余额
		ConfigCenter.GetInstance().SetLastBalance(nNewBalance);

		ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
		for (WeakReference<WangcaiAppEvent> weakPtr: listEventLinsteners) {
			WangcaiAppEvent eventLinstener = weakPtr.get();
			eventLinstener.OnBalanceUpdate(nCurrentBalance, nNewBalance);
		}
	}
	public void RequestExchangeListInfo() {
    	Request_GetExchangeList req = (Request_GetExchangeList)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_GetExchangeList);
    	req.SetAppName(BuildSetting.sg_strAppName);
    	req.SetVersion(SystemInfo.GetVersion());
    	req.SetTimeStamp(String.valueOf(System.currentTimeMillis()));
    	RequestManager.GetInstance().SendRequest(req, false, this);		
	}
	public ExchangeListInfo GetExchangeListInfo() {
		return m_exchangeListInfo;
	}
	@Override
	public boolean RequestManagerOnComplete(Requester req, boolean bOverwrite,
			IRequestManagerCallback pCallback) {
		// TODO Auto-generated method stub
		return false;
	}
	@Override
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_Login) {
			int nResult = req.GetResult();
			LogUtil.LogUserInfo("Request_Login  .GetResult() (%d)", req.GetResult());
			
			boolean bFirstLogin = false;
			if (!m_bHasLogin) {
				bFirstLogin = true;
			}
			
			if (nResult == 0){
				m_bHasLogin = true;
				
				Request_Login loginRequester = (Request_Login)req;
				m_bNeedForceUpdate = loginRequester.GetNeedForceUpdate();
				m_strHintMsg = loginRequester.GetTipString();
				m_userInfo = loginRequester.GetUserInfo();
				LogUtil.LogUserInfo("CurrentLevel(%d)  Balance(%d)  TotalIncome(%d)   HasBindPhone(%b)  OfferWallIncome(%d)", 
						m_userInfo.GetCurrentLevel(), 
						m_userInfo.GetBalance(),
						m_userInfo.GetTotalIncome(), 
						m_userInfo.HasBindPhone(), 
						m_userInfo.GetOfferWallIncome());
				
				m_extractInfo = loginRequester.GetExtractInfo();
				m_taskListInfo = loginRequester.GetTaskListInfo();
				m_offerWallConfig = loginRequester.GetWallConfig();
				m_nPollElapse = loginRequester.GetPollElapse();

				if (bFirstLogin) {
					OnFirstLogin();
				}
				if (m_nPollTimerId == 0) {
					m_nPollTimerId = TimerManager.GetInstance().StartTimer(60 * 3 * 1000, this);
				}
			}
			ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
			for (WeakReference<WangcaiAppEvent> weakPtr: listEventLinsteners) {
				WangcaiAppEvent eventLinstener = weakPtr.get();
				eventLinstener.OnLoginComplete(bFirstLogin, nResult, req.GetMsg());
			}		
		}
		else if (req instanceof Request_GetExchangeList) {
			Request_GetExchangeList detailReq = (Request_GetExchangeList)req;
			int nRes = req.GetResult();
			String strMsg = req.GetMsg();
			if (nRes == 0) {
				this.m_exchangeListInfo = detailReq.GetExchangeInfo();
				m_nExchangeListVersion ++;
			}
			ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
			for (WeakReference<WangcaiAppEvent> weakPtr: listEventLinsteners) {
				WangcaiAppEvent eventLinstener = weakPtr.get();
				eventLinstener.OnExchangeListRequestComplete(m_nExchangeListVersion, nRes, strMsg);
			}
		}
		else if (req instanceof Request_SurveyList) {
			Request_SurveyList surveyReq = (Request_SurveyList)req;
			int nRes = req.GetResult();
			String strMsg = req.GetMsg();
			if (nRes == 0) {
				m_listSurveyInfo = surveyReq.GetSurveyInfoList();
				m_nSurveyListVersion ++;
			}

			ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
			for (WeakReference<WangcaiAppEvent> weakPtr: listEventLinsteners) {
				WangcaiAppEvent eventLinstener = weakPtr.get();
				eventLinstener.OnSurveyRequestComplete(m_nSurveyListVersion, nRes, strMsg);
			}
		}
		else if (req instanceof Request_Poll) {
			Request_Poll detailReq = (Request_Poll)req;

			LogUtil.LogUserInfo(String.format(Locale.CHINA, "Request_Poll  .GetResult() (%d)", req.GetResult()));
			if (req.GetResult() == 0) {
				boolean bIsNewMsg = detailReq.IsNewMsg();
				if (bIsNewMsg) {
					//新消息todo
				}

				int nLevelChange = 0;
				int nCurrentLevel = detailReq.GetCurrentLevel();
				LogUtil.LogUserInfo("Request_Poll  Ret  Level (%d)", nCurrentLevel);
				if (nCurrentLevel > 0) {
					if (m_userInfo.GetCurrentLevel() < nCurrentLevel) {
						nLevelChange = 200;
					}
					m_userInfo.SetCurrentLevel(nCurrentLevel);
					m_userInfo.SetCurrentExperience(detailReq.GetCurrentExperience());
					m_userInfo.SetNextLevelExperience(detailReq.GetNextLevelExperience());
					
					int nBenefit = detailReq.GetBenefit();
					if (nBenefit > 0) {
						m_userInfo.SetBenefit(nBenefit);
					}
					
					//通知等级改变
					if (nLevelChange > 0) {
					ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners1 = GetEventListClone();
						for (WeakReference<WangcaiAppEvent> weakPtr:listEventLinsteners1) {
							WangcaiAppEvent eventLinstener = weakPtr.get();
							eventLinstener.OnLevelChanged(nCurrentLevel, nLevelChange);
						}
					}
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
				LogUtil.LogUserInfo("Request_Poll  NewOfferWallIncome(%d)  PreOfferWallIncome(%d)  WangcaiIncome(%d)  ", 
						nOfferWallIncome, nPreOfferWallIncome, nWangcaiIncome);
				if (nOfferWallIncome > nPreOfferWallIncome || nWangcaiIncome > 0) {
					m_userInfo.SetOfferWallIncome(nOfferWallIncome);

					int nNewOfferWallIncome = nOfferWallIncome - nPreOfferWallIncome;
					int nNewIncome = nNewOfferWallIncome + nWangcaiIncome; 
					if (nNewIncome > 0) {
						LogUtil.LogNewPurse("Fire New Purse Event(%d)", nNewIncome);
						boolean bNeedPending = true;
						ArrayList<WeakReference<WangcaiAppEvent>> listEventLinsteners = GetEventListClone();
						for (WeakReference<WangcaiAppEvent> weakPtr:listEventLinsteners) {
							WangcaiAppEvent eventLinstener = weakPtr.get();
							if (eventLinstener.OnGetAppAward(nNewIncome)) {
								bNeedPending = false;
							}
						}
						if (bNeedPending) {
							LogUtil.LogNewPurse("Need Pending Show Purse Tip(%d)", nNewIncome);
							m_nPendingPurseTip += nNewIncome;
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
	
	public int GetPendingPurse() {
		return m_nPendingPurseTip;
	}
	public void ResetPendingPurse() {
		m_nPendingPurseTip = 0;
	}
	public void PlaySound() {
		if (m_soundPool == null) {
			m_soundPool = new SoundPool(1, AudioManager.STREAM_MUSIC, 100);
			m_soundPool.setOnLoadCompleteListener(new SoundPool.OnLoadCompleteListener() {  
	            @Override  
	            public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
	            	DoPlaySound();
	            }  
	        });  
			
			m_nGetIconSoundId = m_soundPool.load(m_AppContext, R.raw.gotcoins, 1);
		}	
		else {
			DoPlaySound();
		}
	}   
	private void DoPlaySound() {		
		m_soundPool.play(m_nGetIconSoundId, 07f, 0.7f, 1, 0, 1f);		
	}
	public void OnTimer(int nId, int nHitTimes) {
		if (nId == m_nPollTimerId) {
			if (IsForceGround()) {
				this.QueryChanges();
			}
		}
	}
	public void QueryChanges() {
		LogUtil.LogUserInfo("QueryChanges");
		Request_Poll req = (Request_Poll)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Poll);
		RequestManager.GetInstance().SendRequest(req, false, this);		
	}
	
	//登陆
	public boolean Login() {
		RequestManager requestManager = RequestManager.GetInstance();
		Request_Login request = (Request_Login)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Login);
		request.SetSign(Util.GetSignMd5(m_AppContext));
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
    public OfferWallManager GetOfferWallConfig() {
    	return m_offerWallConfig; 
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
    public void RequestSurveyInfo() {
		RequestManager requestManager = RequestManager.GetInstance();
		Request_SurveyList request = (Request_SurveyList)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_SurveyList);
		request.SetAppName(BuildSetting.sg_strAppName);
		request.SetVersion(SystemInfo.GetVersion());
		requestManager.SendRequest(request, true, this);    	
    }
    public ArrayList<SurveyInfo> GetSurveyInfo() {
    	return m_listSurveyInfo;
    }
    public int GetSurveyListVersion() {
    	return m_nSurveyListVersion;
    }
    public SurveyInfo GetSurveyInfo(int nId) {
    	if (m_listSurveyInfo == null) {
    		return null;
    	}
    	for (SurveyInfo info : m_listSurveyInfo) {
    		if (info.m_nId == nId) {
    			return info;
    		}
    	}
    	return null;
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
  
    private ExchangeListInfo m_exchangeListInfo = null;
    private int m_nPendingPurseTip = 0;
    
	private UserInfo m_userInfo = null;
	private TaskListInfo m_taskListInfo = null;	
	private ExtractInfo m_extractInfo = null;

	private int m_nGetIconSoundId = 0;
	
	private String m_strHintMsg = null;
	private String m_strPhoneId = null;	
	private boolean m_bNeedForceUpdate = false;
	private boolean m_bHasLogin = false;
	private ArrayList<TaskInfo> m_listTaskInfos = null;
	private OfferWallManager m_offerWallConfig = null;
	
	private int m_nPollElapse = 0;
	private Context m_AppContext = null;
	private boolean m_bForceGround = false;;
	private int m_nPollTimerId = 0;

	private ArrayList<SurveyInfo> m_listSurveyInfo = null;
	
	private SoundPool m_soundPool = null;
	private ArrayList<WeakReference<WangcaiAppEvent>> m_listEventLinsteners = new ArrayList<WeakReference<WangcaiAppEvent>>();
	private int m_nSurveyListVersion = 1;
	private int m_nExchangeListVersion = 1;
	private boolean m_bInited = false;
}
