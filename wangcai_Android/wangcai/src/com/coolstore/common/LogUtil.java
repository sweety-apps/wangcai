package com.coolstore.common;


public class LogUtil {
	private final static boolean sg_bEnableLog = false; 
	public final static boolean sg_bLogToFile = false;

	public static void LogMainListDrag(String format, Object... args) {
		if (sg_bEnableLog)
			SLog.i("MainListDrag", String.format(format, args));
	}
	public static void LogMainListDrag(String strMsg) {
		if (sg_bEnableLog)
			SLog.i("MainListDrag", strMsg);
	}
	

	public static void LogPush(String format, Object... args) {
		if (sg_bEnableLog)
			SLog.i("JPush", String.format(format, args));
	}
	public static void LogPush(String strMsg) {
		if (sg_bEnableLog)
			SLog.i("JPush", strMsg);
	} 
	

	public static void LogUserInfo(String format, Object... args) {
		if (sg_bEnableLog)
			SLog.i("UserInfo", String.format(format, args));
	}
	public static void LogUserInfo(String strMsg) {
		if (sg_bEnableLog)
			SLog.i("UserInfo", strMsg);
	} 
	
	
	public static void LogWangcai(String format, Object... args) {
		if (sg_bEnableLog)
			SLog.i("Wangcai", String.format(format, args));
	}
	public static void LogWangcai(String strMsg) {
		if (sg_bEnableLog)
			SLog.i("Wangcai", strMsg);
	} 
	
	
	public static void LogNewPurse(String format, Object... args) {
		if (sg_bEnableLog)
			SLog.i("NewPurse", String.format(format, args));
	}
	public static void LogNewPurse(String strMsg) {
		if (sg_bEnableLog)
			SLog.i("NewPurse", strMsg);
	} 
}
