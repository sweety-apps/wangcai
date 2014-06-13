package com.coolstore.common;


import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Hashtable;
import java.util.Map;
import java.util.Map.Entry;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;

import org.json.JSONException;
import org.json.JSONObject;

import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ActivityHelper;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;


public class Util {
	
	public static int ReadJsonInt(JSONObject jsonObj, String strKey) {
		try {
			return jsonObj.getInt(strKey);
		} catch (JSONException e) {
			return 0;
		}
	}
	public static boolean ReadJsonBool(JSONObject jsonObj, String strKey) {
		try {
			return jsonObj.getInt(strKey) != 0;
		} catch (JSONException e) {
			return false;
		}
	}
	public static String ReadJsonString(JSONObject jsonObj, String strKey) {
		try {
			return jsonObj.getString(strKey);
		} catch (JSONException e) {
			return "";
		}
	}
	
	@SuppressLint("NewApi") public static boolean IsEmptyString(String strVal) {
		return strVal == null || strVal.isEmpty() || strVal.equals("");
	}


	public static Bitmap CreateQRCodeBitmap(String strContent, int nSize) {
		Hashtable<EncodeHintType, String> hints = new Hashtable<EncodeHintType, String>();  
        hints.put(EncodeHintType.CHARACTER_SET, "utf-8"); 
		BitMatrix matrix = null;
		try {
			matrix = new MultiFormatWriter().encode(strContent,
					BarcodeFormat.QR_CODE, nSize, nSize);
		} catch (WriterException e) {
			return null;
		}
		int nWidth = matrix.getWidth();
		int nHeight = matrix.getHeight();
		int[] bufPixels = new int[nWidth * nHeight];
		
		int nColor = Color.rgb(0, 0, 0);
		for (int y = 0; y <  nHeight; y++) {
			int nBeginIndex= y * nWidth;
			for (int x = 0; x < nWidth; x++) {
				if (matrix.get(x, y)) {
					bufPixels[nBeginIndex + x] = nColor;
				}
			}
		}
		Bitmap bitmap = Bitmap.createBitmap(nWidth, nHeight, Bitmap.Config.ARGB_8888);
		bitmap.setPixels(bufPixels, 0, nWidth, 0, 0, nWidth, nHeight);
		return bitmap;
	}
	public static void ShowRequestErrorMsg(Activity owner, String strMsg) {
		if (Util.IsEmptyString(strMsg)) {
			ActivityHelper.ShowToast(owner, R.string.hint_request_error);
		}
		else {
			ActivityHelper.ShowToast(owner, strMsg);					
		}
	}
	public static String CombineNetworkData(String strData1, String strData2) {
		if (!Util.IsEmptyString(strData1)) {
			strData1 += "&";
		}
		strData1 += strData2;	
		return strData1;		
	}
	public static String FormatNetworkData(Map<String, String> mapData) {
		if (mapData.isEmpty()) {
			return "";
		}
		StringBuffer stringBuffer = new StringBuffer();
		for (Entry<String, String> entry : mapData.entrySet()) {
			   String strKey = entry.getKey();			   
			   String strValue = entry.getValue();
			   if (!Util.IsEmptyString(strKey) && !Util.IsEmptyString(strValue)) {
				   stringBuffer.append(strKey);
				   stringBuffer.append("=");
				   stringBuffer.append(strValue);
				   stringBuffer.append("&");
			   }
		}
		stringBuffer.deleteCharAt(stringBuffer.length() - 1);
		return stringBuffer.toString();
	}
	public static String AddData2Url(String strUrl, String strData) {
		if (!strUrl.contains("?")) {
			strUrl += ("?" + strData);
		}
		else {
			strUrl = CombineNetworkData(strUrl, strData);				
		}
		return strUrl;
	}
	public static String GetStringMd5(String strVal) {
		MessageDigest md5 = null;
		try {
			md5 = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			return "";
		}    
        md5.update(strVal.getBytes());    
        byte[] m = md5.digest();
        return toHexString(m);    
	}
	private static final char HEX_DIGITS[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
	public static String toHexString(byte[] b) {  //String to  byte
		 StringBuilder sb = new StringBuilder(b.length * 2);  
		 for (int i = 0; i < b.length; i++) {  
		     sb.append(HEX_DIGITS[(b[i] & 0xf0) >>> 4]);  
		     sb.append(HEX_DIGITS[b[i] & 0x0f]);  
		 }  
		 return sb.toString();  
	}
	
	public static String FormatMoney(int nMoney) {
		String strText = String.format("%.2f", (float)nMoney / 100.0f);
		int nDotPos = strText.indexOf(".");
		if (nDotPos < 0) {
			return strText;
		}
		int nIndex = strText.length() - 1;
		for (; nIndex > nDotPos; nIndex--) {
			if (strText.charAt(nIndex) != '0') {
				break;
			}
		}
		if (nIndex != nDotPos) {
			nIndex += 1;
		}
		return strText.substring(0, nIndex);
		/*
		String strText = String.valueOf(nMoney / 100);
		if (nMoney % 100 == 0) {
			return strText;
		}

		int nVal1 = nMoney % 10;
		int nVal2 = (nMoney / 10) % 10;
		if (nVal1 != 0) {
			return strText + "." + String.valueOf(nVal2) + String.valueOf(nVal1); 
		}
		else {
			if (nVal2 != 0) {
				return strText + "." + String.valueOf(nVal2); 
			}
			else {
				return strText;
			}
		}*/
	}
	public static boolean SendNotification(Activity owner, int nIconId, String strTitle, String strText) {
        NotificationManager manager = (NotificationManager) owner .getSystemService(Context.NOTIFICATION_SERVICE);
        Notification notification = new Notification();
        notification.icon = nIconId;
        notification.tickerText = strTitle;
        /***
         * notification.contentIntent:一个PendingIntent对象，当用户点击了状态栏上的图标时，该Intent会被触发
         * notification.contentView:我们可以不在状态栏放图标而是放一个view
         * notification.deleteIntent 当当前notification被移除时执行的intent
         * notification.vibrate 当手机震动时，震动周期设置
         */
        // 添加声音提示
        notification.defaults = Notification.DEFAULT_SOUND;
        // audioStreamType的值必须AudioManager中的值，代表着响铃的模式
        notification.audioStreamType= android.media.AudioManager.ADJUST_LOWER;
         
        //下边的两个方式可以添加音乐
        //notification.sound = Uri.parse("file:///sdcard/notification/ringer.mp3");
        //notification.sound = Uri.withAppendedPath(Audio.Media.INTERNAL_CONTENT_URI, "6");
        Intent intent = new Intent(owner, Activity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(owner, 0, intent, PendingIntent.FLAG_ONE_SHOT);
        // 点击状态栏的图标出现的提示信息设置
        notification.setLatestEventInfo(owner, strTitle, strText, pendingIntent);
        manager.notify(1, notification);
		return true;
	}
}







