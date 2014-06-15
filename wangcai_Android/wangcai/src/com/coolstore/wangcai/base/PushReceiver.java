package com.coolstore.wangcai.base;

import java.lang.ref.WeakReference;
import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.common.LogUtil;
import com.coolstore.common.SLog;
import com.coolstore.common.Util;

import cn.jpush.android.api.JPushInterface;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;



public class PushReceiver extends BroadcastReceiver {
	public final static int nPushType_Normal = 1;
	public final static int nPushType_Custom = 2;
	
	
	public final static int nMessageType_NewAward = 1;
	
	public class PushInfo {
		public PushInfo(int nPushType, int nTextType, String strTitle, String strText) {
			m_nPushType = nPushType;
			m_nTextType = nTextType;
			m_strTitle = strTitle;
			m_strText = strText;
		}
		public int m_nPushType;
		public int m_nTextType;
		public String m_strTitle;
		public String m_strText;
	}
	public interface PushEvent {
		void OnNewPushMsg(PushInfo pushInfo);
	}
	private static ArrayList<WeakReference<PushEvent>> m_listEventListener = null;

	public static void AddListener(PushEvent eventListener) {
		if (m_listEventListener == null) {
			m_listEventListener = new ArrayList<WeakReference<PushEvent>>();
		}

		if (m_listEventListener.contains(eventListener)) {
			return ;
		}
		m_listEventListener.add(new WeakReference<PushEvent>(eventListener));
	}
	public static void RemoveListener(PushEvent eventListener) {
		if (m_listEventListener == null) {
			return;
		}
		
		m_listEventListener.remove(eventListener);
	}
	
	@Override
	public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
		//LogUtil.LogPush("[PushReceiver] onReceive - " + intent.getAction() + ", extras: " + printBundle(bundle));

        if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
           // String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
            //LogUtil.LogPush("[PushReceiver] 接收Registration Id : " + regId);
            //send the Registration Id to your server...
                        
        }
        else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
        	String strRawText = bundle.getString(JPushInterface.EXTRA_MESSAGE);   
        	LogUtil.LogPush("[PushReceiver] New Custom Push Message: " + strRawText);     	
     	   if (m_listEventListener == null) {
     		  LogUtil.LogPush("has no listener Skip");
    		   return;
    	   }

			String strMsgType = null;;
			String strTitle = null;
			String strMsg = null;
			try {
				JSONObject rootObject = new JSONObject(strRawText);
				strMsgType = Util.ReadJsonString(rootObject, "type");
				strTitle = Util.ReadJsonString(rootObject, "title");
				strMsg = Util.ReadJsonString(rootObject, "text");
			} catch (JSONException e) {
				LogUtil.LogPush("Parse Json fail: " + e.toString());
				// TODO Auto-generated catch block
				return ;
			}
			int nMsgType = 0;
			if (Util.IsEmptyString(strMsgType) || strMsgType.equals("NewAward")) {
				nMsgType = nMessageType_NewAward;
			}
			else {
				LogUtil.LogPush("Unknwon msg type");
				return;
			}
			PushInfo pushInfo = new PushInfo(nPushType_Custom, nMsgType, strTitle, strMsg);
			for (WeakReference<PushEvent> eventListener:m_listEventListener) {
				PushEvent listener = eventListener.get();
				if (listener != null) {
					listener.OnNewPushMsg(pushInfo);
				}
			}
        } 
        else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
            //LogUtil.LogPush("[PushReceiver] 接收到推送下来的通知");
            int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);
            LogUtil.LogPush("[PushReceiver] 接收到推送下来的通知的ID: " + notifactionId);
        	
        }
        else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
           LogUtil.LogPush("[PushReceiver] 用户点击打开了通知");
            
            JPushInterface.reportNotificationOpened(context, bundle.getString(JPushInterface.EXTRA_MSG_ID));
            
            /*
	        	//打开自定义的Activity
	        	Intent i = new Intent(context, TestActivity.class);
	        	i.putExtras(bundle);
	        	i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	        	context.startActivity(i);
        	*/
        }
        else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
            LogUtil.LogPush("[PushReceiver] 用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
            //在这里根据 JPushInterface.EXTRA_EXTRA 的内容处理代码，比如打开新的Activity， 打开一个网页等..           
        } 
        else {
        	LogUtil.LogPush("[PushReceiver] Unhandled intent - " + intent.getAction());
        }
	}

	// 打印所有的 intent extra 数据
	private static String printBundle(Bundle bundle) {
		StringBuilder sb = new StringBuilder();
		for (String key : bundle.keySet()) {
			if (key.equals(JPushInterface.EXTRA_NOTIFICATION_ID)) {
				sb.append("\nkey:" + key + ", value:" + bundle.getInt(key));
			} else {
				sb.append("\nkey:" + key + ", value:" + bundle.getString(key));
			}
		}
		return sb.toString();
	}
	
	//send msg to MainActivity
	private void processCustomMessage(Context context, Bundle bundle) {
		/*
		if (MainActivity.isForeground) {
			String message = bundle.getString(JPushInterface.EXTRA_MESSAGE);
			String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
			Intent msgIntent = new Intent(MainActivity.MESSAGE_RECEIVED_ACTION);
			msgIntent.putExtra(MainActivity.KEY_MESSAGE, message);
			if (!ExampleUtil.isEmpty(extras)) {
				try {
					JSONObject extraJson = new JSONObject(extras);
					if (null != extraJson && extraJson.length() > 0) {
						msgIntent.putExtra(MainActivity.KEY_EXTRAS, extras);
					}
				} catch (JSONException e) {

				}

			}
			context.sendBroadcast(msgIntent);
		}
		*/
	}
}
