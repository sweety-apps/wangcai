package com.coolstore.common;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Enumeration;

import org.apache.http.conn.util.InetAddressUtils;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.provider.Settings;
import android.telephony.TelephonyManager;

public class SystemInfo {
	public static String sg_strNetworkWifi = "wifi";
	public static String sg_strNetwork2G = "2g";
	public static String sg_strNetwork3G = "3g";
	public static String sg_strNetwork4G = "4g";
	
	public static void Initialize(Context context) {
		m_AppContext = context;
	}
	public static String GetMacAddress() {
		if (ms_strMacAddress == null) {
			WifiManager wifi = (WifiManager) m_AppContext.getSystemService(Context.WIFI_SERVICE);  
	        WifiInfo info = wifi.getConnectionInfo();  
	        ms_strMacAddress =  info.getMacAddress(); 
	        if (!Util.IsEmptyString(ms_strMacAddress)) {
	        	ms_strMacAddress = ms_strMacAddress.replace(":", "");
	        }
		}
		if (BuildSetting.sg_bIsDebug) {
			if (Util.IsEmptyString(ms_strMacAddress)) {
				ms_strMacAddress = "240A64F9DAC7"; 
			}
		}
		return ms_strMacAddress;
	}
	public static String GetPhoneNumber() {
		if (ms_strPhoneNumber == null) {
			TelephonyManager  telephonyManager = (TelephonyManager) m_AppContext.getSystemService(Context.TELEPHONY_SERVICE);  
			ms_strPhoneNumber = telephonyManager.getLine1Number();
		}
		return ms_strPhoneNumber;
	}
	public static String GetSystemVersion() {
		return android.os.Build.VERSION.RELEASE;
	}
	@SuppressLint("NewApi")
	public static String GetSerial() {
		return android.os.Build.SERIAL;
	}
	public static String GetPhoneModel() {
		return android.os.Build.PRODUCT;
	}
	public static String GetIp() { 
		String strIpAddress = "";
		try {  
	        for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {  
	            NetworkInterface intf = en.nextElement();  
	            for (Enumeration<InetAddress> enumIpAddr = intf.getInetAddresses(); enumIpAddr.hasMoreElements();) {  
	                InetAddress inetAddress = enumIpAddr.nextElement();  
	                if (!inetAddress.isLoopbackAddress() && InetAddressUtils.isIPv4Address(inetAddress.getHostAddress())) {  
	                	strIpAddress = inetAddress.getHostAddress().toString();  
	                	break;
	                }  
	            }  
	        }
	    } catch (Exception ex) {  
	    }
	    return strIpAddress;  
	}
	public static String GetNetworkType() {
		ConnectivityManager connectMgr = (ConnectivityManager) m_AppContext
		        .getSystemService(Context.CONNECTIVITY_SERVICE);
		 
		 NetworkInfo info = connectMgr.getActiveNetworkInfo();
		 if (info == null) {
			 return "";
		 }
		 String strType = "";
		 int nType = info.getType();
		 if (nType == ConnectivityManager.TYPE_WIFI) {
			 strType = sg_strNetworkWifi;
		 }
		 else if (nType == ConnectivityManager.TYPE_MOBILE) {
			 int nSubType = info.getSubtype();
			 switch (nSubType) {
			 case TelephonyManager.NETWORK_TYPE_CDMA:
			 case TelephonyManager.NETWORK_TYPE_EDGE:
			 case TelephonyManager.NETWORK_TYPE_GPRS:
			 case TelephonyManager.NETWORK_TYPE_IDEN:
				 strType = sg_strNetwork2G;
				 break;
			 case TelephonyManager.NETWORK_TYPE_UMTS:
			 case TelephonyManager.NETWORK_TYPE_HSDPA:
			 case TelephonyManager.NETWORK_TYPE_HSUPA:
			 case TelephonyManager.NETWORK_TYPE_HSPA:
			 case TelephonyManager.NETWORK_TYPE_EVDO_A:
			 case TelephonyManager.NETWORK_TYPE_EVDO_B:
			 case TelephonyManager.NETWORK_TYPE_EVDO_0:
			 case TelephonyManager.NETWORK_TYPE_EHRPD:
			 case TelephonyManager.NETWORK_TYPE_HSPAP:
				 strType = sg_strNetwork3G;
				 break;
			 case TelephonyManager.NETWORK_TYPE_LTE:
				 strType = sg_strNetwork4G;
				 break;
			 }
		 }
		 return strType;
	}
	public static String GetImsi() {
		try {
			return ((TelephonyManager) m_AppContext.getSystemService(Context.TELEPHONY_SERVICE)).getSubscriberId();
		}
		catch (Exception E) {
			return "";
		}
	}
	public static String GetImei() {
		try {
			return ((TelephonyManager) m_AppContext.getSystemService(Context.TELEPHONY_SERVICE)).getDeviceId();
		}
		catch (Exception E) {
			return "";
		}
	}
	public static String GetAndroidId() {
		try {
			return Settings.Secure.getString(m_AppContext.getContentResolver(), Settings.Secure.ANDROID_ID);	
		}
		catch (Exception E) {
			return "";
		}	
	}
	public static String GetVersion() {
		if (ms_strVersionName == null){
			try {
				PackageManager pm = m_AppContext.getPackageManager();
				 
				PackageInfo pinfo = pm.getPackageInfo(m_AppContext.getPackageName(), PackageManager.GET_CONFIGURATIONS);
				ms_strVersionName = pinfo.versionName;
			} catch (Exception e) {
				return "0.0.5";
			}
		}
		return ms_strVersionName;
	}
	private static String ms_strVersionName;
	private static String ms_strMacAddress;
	private static String ms_strPhoneNumber;
	private static Context m_AppContext;
}
