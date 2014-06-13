package com.coolstore.wangcai;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Iterator;

import net.youmi.android.AdManager;
import net.youmi.android.offers.OffersManager;
import cn.jpush.android.api.JPushInterface;
import cn.sharesdk.framework.ShareSDK;

import com.coolstore.common.BuildSetting;
import com.coolstore.common.Config;
import com.coolstore.common.SLog;
import com.coolstore.common.SystemInfo;
import com.coolstore.common.TimerManager;
import com.coolstore.common.Util;
import com.coolstore.request.AppWallConfig;
import com.coolstore.request.ExtractInfo;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.TaskListInfo;
import com.coolstore.request.UserInfo;
import com.coolstore.request.Requesters.Request_Login;
import com.coolstore.request.Requesters.Request_Poll;
import com.coolstore.wangcai.base.PushReceiver;
import com.coolstore.wangcai.base.PushReceiver.PushInfo;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.telephony.TelephonyManager;
import android.util.Log;

public class WangcaiApp implements 
									RequestManager.IRequestManagerCallback, 
									PushReceiver.PushEvent,
									TimerManager.TimerManagerCallback{
	public interface WangcaiAppEvent {
		void OnLoginComplete(int nResult, String strMsg);
		void OnUserInfoUpdate();
		void OnBalanceUpdate(int nCurrentBalance, int nNewBalance);
		void OnLevelChanged(int nLevel, int nLevelChange);
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
		
		PushReceiver.AddListener(this);
	}

	public void Init3rdSdk() {
    	ShareSDK.initSDK(m_AppContext);

		String strDeviceId = m_userInfo.GetDeviceId();
		
		//有米
        AdManager.getInstance(m_AppContext).init(Config.sg_strYoumiAppId, Config.sg_strYoumiAppSecret, false);
        AdManager.getInstance(m_AppContext).setEnableDebugLog(false);
        
        OffersManager.getInstance(m_AppContext).setCustomUserId(strDeviceId);
		OffersManager.getInstance(m_AppContext).onAppLaunch();
	
		//极光推送
		JPushInterface.setAlias(m_AppContext, strDeviceId, null);
        JPushInterface.setDebugMode(BuildSetting.sg_bIsDebug);
		JPushInterface.init(m_AppContext);
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
			//send();			
		}
		else if (req instanceof Request_Poll) {
			Request_Poll detailReq = (Request_Poll)req;

			SLog.i("PollIncome", String.format("req.GetResult() (%d)", req.GetResult()));
			if (req.GetResult() == 0) {
				boolean bIsNewMsg = detailReq.IsNewMsg();
				if (bIsNewMsg) {
					//新消息todo
				}

				int nLevelChange = 0;
				int nCurrentLevel = detailReq.GetCurrentLevel();
				SLog.i("PollIncome", String.format("Level (%d)", nCurrentLevel));
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
				SLog.i("PollIncome", String.format("nOfferWallIncome(%d)  nPreOfferWallIncome(%d)  nWangcaiIncome(%d)  ", 
						nOfferWallIncome, nPreOfferWallIncome, nWangcaiIncome));
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
			//if (IsForceGround()) {
			//}
		}
	}
	public void QueryChanges() {
		Request_Poll req = (Request_Poll)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_Poll);
		RequestManager.GetInstance().SendRequest(req, false, this);		
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
    private static class MsgHandler extends Handler {
    	public MsgHandler(WangcaiApp owner) {
    		m_owner = new WeakReference<WangcaiApp>(owner);
    	}
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == sg_nNewPush) {
            	WangcaiApp owner = m_owner.get();
            	if (owner == null) {
            		return;
            	}

                Bundle b = msg.getData();
                
        		int nPushType = b.getInt("PushType");
        		int nMsgType = b.getInt("MsgType");
                String strTitle = b.getString("Title");
                String strMsg = b.getString("Text");
                if (nPushType != PushReceiver.nPushType_Custom) {
                	return;
                }
                
                if (ConfigCenter.GetInstance().ShouldReceivePush() &&
                		(!Util.IsEmptyString(strTitle) || !Util.IsEmptyString(strMsg))) {
                	Util.SendNotification(owner.m_lastActivity, R.drawable.ic_launcher, strTitle, strMsg);
                }
                if (strMsg != null && strMsg.equals(Config.sg_strPushKeyName_NewAward)) {
                	owner.QueryChanges();
                }
            }
            super.handleMessage(msg);
        }
		private WeakReference<WangcaiApp> m_owner;
    }
    private Handler m_handler = new MsgHandler(this);
   
	public void OnNewPushMsg(PushInfo pushInfo) {
		Message msg = new Message();
		msg.what = sg_nNewPush;
		Bundle b = new Bundle();
		b.putInt("PushType", pushInfo.m_nPushType);
		b.putInt("MsgType", pushInfo.m_nTextType);
		b.putString("Title", pushInfo.m_strTitle);
		b.putString("Text", pushInfo.m_strText);
		msg.setData(b);
		m_handler.sendMessage(msg);
	}
	public void SetLastActivity(Activity activity) {
		m_lastActivity = activity;
	}
	
	
    private final static int sg_nNewPush = 1212;

    
	private UserInfo m_userInfo = null;
	private TaskListInfo m_taskListInfo = null;	
	private ExtractInfo m_extractInfo = null;

	private String m_strHintMsg = null;
	private String m_strPhoneId = null;	
	private boolean m_bNeedForceUpdate = false;
	private boolean m_bHasLogin = false;
	private ArrayList<TaskInfo> m_listTaskInfos = null;
	private AppWallConfig m_appWallConfig = null;
	
	private int m_nPollElapse = 0;
	private Context m_AppContext = null;
	private boolean m_bForceGround = false;;
	private int m_nPollTimerId = 0;

	private Activity m_lastActivity = null;
	
	private ArrayList<WeakReference<WangcaiAppEvent>> m_listEventLinsteners = new ArrayList<WeakReference<WangcaiAppEvent>>();
}
