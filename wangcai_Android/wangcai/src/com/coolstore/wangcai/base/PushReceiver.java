package com.coolstore.wangcai.base;


import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.common.LogUtil;
import com.coolstore.common.Util;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.activity.MainActivity;
import com.coolstore.wangcai.activity.WebviewActivity;

import cn.jpush.android.api.JPushInterface;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

//		 自定义消息
//{"type":"NewPurse", "title":"xxx", "text":"xxx"}


public class PushReceiver extends BroadcastReceiver {
	public final static int nPushType_Normal = 1;
	public final static int nPushType_Custom = 2;

	public static final String PushMessageReceiveAction = "com.coolstore.wangcai.PUSH_MESSAGE_RECEIVE";
	
    public final static String sg_nPushType = "nPushType";
    public final static String sg_nPushMessageType = "nMessageType";
    public final static String sg_strPushTitle = "strPushTitle";
    public final static String sg_strPushText = "strPushText";
    
    public final static String sg_strOpeType = "strOpeType";
    public final static String sg_strOpeParam = "strOpeParam";
	
	public PushReceiver() {
		LogUtil.LogPush("###############			NewPushReceiver %x", this.hashCode());
	}
	
	public final static int nMessageType_NewAward = 1;
	
	
	@Override
	public void onReceive(Context context, Intent intent) {
		Bundle bundle = intent.getExtras();
		//LogUtil.LogPush("[PushReceiver] onReceive - " + intent.getAction() + ", extras: " + printBundle(bundle));

        if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {                        
        }
        else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {	
	       	String strRawText = bundle.getString(JPushInterface.EXTRA_MESSAGE);   
	       	LogUtil.LogPush("[PushReceiver]this(%x) New Custom Push Message:(%s)", this.hashCode(), strRawText);   

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
        }
        else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
            LogUtil.LogPush("[PushReceiver] 用户点击打开了通知");
   			Bundle bundle2 = intent.getExtras();

	       	String strTitle = bundle.getString(JPushInterface.EXTRA_NOTIFICATION_TITLE);    
	       	String strMsg = bundle.getString(JPushInterface.EXTRA_ALERT); 

            int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);
            LogUtil.LogPush("[PushReceiver] 接收到推送下来的通知的ID: " + notifactionId);
    
	       	String strExtractData = bundle.getString(JPushInterface.EXTRA_EXTRA);    
	       	if (Util.IsEmptyString(strExtractData)) {
				ShowMainActivity(context);
	       	}
	       	else {
				try {
					JSONObject rootObject = new JSONObject(strExtractData);
					
					String strActivityTitle = Util.ReadJsonString(rootObject, "Title");
					if (!Util.IsEmptyString(strActivityTitle)) {
						strActivityTitle = "旺财";
					}
					
					String strInUrl = Util.ReadJsonString(rootObject, "InUrl");
					if (!Util.IsEmptyString(strInUrl)) {
				    	Intent it = new Intent(context, WebviewActivity.class);
				    	it.putExtra(ActivityHelper.sg_strUrl, strInUrl);
				    	it.putExtra(ActivityHelper.sg_strTitle, strActivityTitle);
				    	it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
				    	context.startActivity(it);
						return;
					}
					String strOutUrl = Util.ReadJsonString(rootObject, "OutUrl");
					if (!Util.IsEmptyString(strOutUrl)) {
						Intent newIntent = new Intent();        
						newIntent.setAction("android.intent.action.VIEW");    
						Uri contentUrl = Uri.parse(strOutUrl);   
						newIntent.setData(contentUrl);  
						newIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
						context.startActivity(newIntent);
						return;
					}

					ShowMainActivity(context);
				} catch (JSONException e) {
					ShowMainActivity(context);
					return ;
				}

	       	}
        }
        else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
            LogUtil.LogPush("[PushReceiver] 用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
            //在这里根据 JPushInterface.EXTRA_EXTRA 的内容处理代码，比如打开新的Activity， 打开一个网页等..           
        } 
        else {
        	LogUtil.LogPush("[PushReceiver] Unhandled intent - " + intent.getAction());
        }
	}
	private void ShowMainActivity(Context context) {
   		Intent intent = new Intent(context, MainActivity.class);
   		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
   		context.startActivity(intent);	
	}
	
}
