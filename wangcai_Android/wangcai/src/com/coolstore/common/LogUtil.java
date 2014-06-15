package com.coolstore.common;


public class LogUtil {

	public static void LogMainListDrag(String format, Object... args) {
		SLog.i("MainListDrag", String.format(format, args));
	}
	public static void LogMainListDrag(String strMsg) {
		SLog.i("MainListDrag", strMsg);
	}
	

	public static void LogPush(String format, Object... args) {
		SLog.i("JPush", String.format(format, args));
	}
	public static void LogPush(String strMsg) {
		SLog.i("JPush", strMsg);
	} 
	

	public static void LogUserInfo(String format, Object... args) {
		SLog.i("UserInfo", String.format(format, args));
	}
	public static void LogUserInfo(String strMsg) {
		SLog.i("UserInfo", strMsg);
	} 
	
	
	public static void LogWangcai(String format, Object... args) {
		SLog.i("Wangcai", String.format(format, args));
	}
	public static void LogWangcai(String strMsg) {
		SLog.i("Wangcai", strMsg);
	} 
	
	
	public static void LogNewPurse(String format, Object... args) {
		SLog.i("NewPurse", String.format(format, args));
	}
	public static void LogNewPurse(String strMsg) {
		SLog.i("NewPurse", strMsg);
	} 
}
