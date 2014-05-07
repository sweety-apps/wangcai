


package com.example.wangcai;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.SmsMessage;


public class SmsReader extends BroadcastReceiver
{

    public static final String TAG = "ImiChatSMSReceiver";
    public static final String SMS_RECEIVED_ACTION = "android.provider.Telephony.SMS_RECEIVED";

    @Override
    public void onReceive(Context context, Intent intent)
    {
       if (intent.getAction().equals(SMS_RECEIVED_ACTION))
       {
           SmsMessage[] arraySmsMsgs = GetMessagesFromIntent(intent);
           for (SmsMessage message : arraySmsMsgs)
           {
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






