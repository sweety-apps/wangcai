package com.coolstore.wangcai.base;

import java.lang.ref.WeakReference;
import java.util.ArrayList;

import com.coolstore.wangcai.base.SmsReader.SmsEvent;

import cn.jpush.android.api.JPushInterface;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;



public class PushReceiver extends BroadcastReceiver {
	private static final String TAG = "JPush";

	public interface PushEvent {
		void OnNewCustomMsg(String strMsg);
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
		//Log.d(TAG, "[MyReceiver] onReceive - " + intent.getAction() + ", extras: " + printBundle(bundle));
		
        if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
           // String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
            //Log.d(TAG, "[MyReceiver] ����Registration Id : " + regId);
            //send the Registration Id to your server...
                        
        }
        else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
        	//Log.d(TAG, "[MyReceiver] ���յ������������Զ�����Ϣ: " + );
        	String strMsg = bundle.getString(JPushInterface.EXTRA_MESSAGE);        	

     	   for (WeakReference<PushEvent> eventListener:m_listEventListener) {
     		  PushEvent listener = eventListener.get();
     		   if (listener != null) {
     			   listener.OnNewCustomMsg(strMsg);
     		   }
     		}  
        } 
        else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
            //Log.d(TAG, "[MyReceiver] ���յ�����������֪ͨ");
            int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);
            //Log.d(TAG, "[MyReceiver] ���յ�����������֪ͨ��ID: " + notifactionId);
        	
        }
        else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
            //Log.d(TAG, "[MyReceiver] �û��������֪ͨ");
            
            JPushInterface.reportNotificationOpened(context, bundle.getString(JPushInterface.EXTRA_MSG_ID));
            
            /*
	        	//���Զ����Activity
	        	Intent i = new Intent(context, TestActivity.class);
	        	i.putExtras(bundle);
	        	i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	        	context.startActivity(i);
        	*/
        }
        else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
            Log.d(TAG, "[MyReceiver] �û��յ���RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
            //��������� JPushInterface.EXTRA_EXTRA �����ݴ�����룬������µ�Activity�� ��һ����ҳ��..           
        } 
        else {
        	Log.d(TAG, "[MyReceiver] Unhandled intent - " + intent.getAction());
        }
	}

	// ��ӡ���е� intent extra ����
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
