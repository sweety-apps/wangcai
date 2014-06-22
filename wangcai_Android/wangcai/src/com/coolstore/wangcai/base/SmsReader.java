


package com.coolstore.wangcai.base;

import com.coolstore.common.Util;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.SmsMessage;
import android.util.Log;


public class SmsReader extends BroadcastReceiver
{
    public static final String TAG = "ImiChatSMSReceiver";
    public static final String SMS_RECEIVED_ACTION = "android.provider.Telephony.SMS_RECEIVED";
    
    public static final String sg_strSmsContent = "strSmsContent";

	public static final String SmsMessageReceiveAction = "com.coolstore.wangcai.SMS_MESSAGE_RECEIVE";
	
	
	@Override
    public void onReceive(Context context, Intent intent)
    {
	   Log.i("SMS", intent.getAction());
       if (intent.getAction().equals(SMS_RECEIVED_ACTION))
       {
           SmsMessage[] arraySmsMsgs = GetMessagesFromIntent(intent);
           for (SmsMessage message : arraySmsMsgs) {
        	   //getMessageBody
        	   String strMsg = "";
        	   try {
            	   strMsg = message.getDisplayMessageBody();        		   
        	   }
        	   catch (Exception e) {
        	   }
        	   
        	   if (Util.IsEmptyString(strMsg)) {
        		   continue;
        	   }
	
	   			Intent msgIntent = new Intent(SmsMessageReceiveAction);
	   			msgIntent.putExtra(sg_strSmsContent, strMsg);
	   			context.sendBroadcast(msgIntent);
           }
       }
    }
   

    public final SmsMessage[] GetMessagesFromIntent(Intent intent)
    {
        Object[] arrayMsgs = (Object[]) intent.getSerializableExtra("pdus");
        byte[][] pduObjs = new byte[arrayMsgs.length][];
        for (int i = 0; i < arrayMsgs.length; i++)
        {
            pduObjs[i] = (byte[]) arrayMsgs[i];
        }

        byte[][] pdus = new byte[pduObjs.length][];
        int pduCount = pdus.length;
        SmsMessage[] msgs = new SmsMessage[pduCount];
        for (int i = 0; i < pduCount; i++)
        {
            pdus[i] = pduObjs[i];
            msgs[i] = SmsMessage.createFromPdu(pdus[i]);
        }
        return msgs;
    }
    
    
     
}






