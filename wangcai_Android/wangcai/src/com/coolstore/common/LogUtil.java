package com.coolstore.common;

import android.util.Log;

public class LogUtil {

	public static void LogMainListDrag(String format, Object... args) {
		Log.i("MainListDrag", String.format(format, args));
	}
	public static void LogMainListDrag(String strMsg) {
		Log.i("MainListDrag", strMsg);
	}
}
