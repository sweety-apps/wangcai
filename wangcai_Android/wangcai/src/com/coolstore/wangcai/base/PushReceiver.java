package com.coolstore.wangcai.base;

import java.lang.ref.WeakReference;
import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.common.LogUtil;
import com.coolstore.common.SLog;
import com.coolstore.common.Util;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.activity.MainActivity;
import com.coolstore.wangcai.activity.StartupActivity;

import cn.jpush.android.api.JPushInterface;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;



public class PushReceiver extends BroadcastReceiver {
	public final static int nPushType_Normal = 1;
	public final static int nPushType_Custom = 2;

	public static final String PushMessageReceiveAction = "com.coolstore.wangcai.PUSH_MESSAGE_RECEIVE";
	
    public final static String sg_nPushType = "nPushType";
    public final static String sg_nPushMessageType = "nMessageType";
    public final static String sg_strPushTitle = "strPushTitle";
    public final static String sg_strPushText = "strPushText";
	
	public PushReceiver() {
		LogUtil.LogPush("###############			NewPushReceiver %x", this.hashCode());
	}
	
	public final static int nMessageType_NewAward = 1;
	
	
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
	       	LogUtil.LogPush("[PushReceiver]this(%x) New Custom Push Message:(%s)", this.hashCode(), strRawText);     
			//Util.SendNotification(this, R.drawable.ic_launcher, "旺财", "旺财");
			//if (m_listEventListener == null) {
			//	  LogUtil.LogPush("has no listener Skip");
			//  return;
			//}

			String strMsgType = null;;
			String strTitle = null;
			String strText = null;
			try {
				JSONObject rootObject = new JSONObject(strRawText);
				strMsgType = Util.ReadJsonString(rootObject, "type");
				strTitle = Util.ReadJsonString(rootObject, "title");
				strText = Util.ReadJsonString(rootObject, "text");
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
    		if (PushReceiver.nMessageType_NewAward == nMsgType) {
    			if (Util.IsEmptyString(strTitle)) {
    				strTitle = "旺财收到新红包";
    			}
            	if (Util.IsEmptyString(strText)) {
            		strText = "点击查看详情";
            	}
    		}
			if (Util.IsEmptyString(strTitle)) {
				strTitle = "旺财";
			}
    		
    		//发广播
			Intent msgIntent = new Intent(PushMessageReceiveAction);
			msgIntent.putExtra(sg_nPushType, nPushType_Custom);
			msgIntent.putExtra(sg_nPushMessageType, nMsgType);
			msgIntent.putExtra(sg_strPushTitle, strTitle);
			msgIntent.putExtra(sg_strPushText, strText);
			context.sendBroadcast(msgIntent);
			LogUtil.LogPush("sendBroadcast");

    		if (PushReceiver.nMessageType_NewAward == nMsgType) {
    			//通知栏
	            Intent activtiyIntent = new Intent(context, MainActivity.class);
	            //activtiyIntent.setAction(Intent.ACTION_MAIN);
	            //activtiyIntent.addCategory(Intent.CATEGORY_LAUNCHER);
	            activtiyIntent.putExtra(MainActivity.sg_nIntentType, MainActivity.sg_nIntentType_NewPurseNotification);
				Util.SendNotification(context, activtiyIntent, R.drawable.ic_launcher, strTitle, strText);
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
	

	/*
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
	*/

	/*
	//send msg to MainActivity
	private void processCustomMessage(Context context, Bundle bundle) {
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
	}
		*/
}
