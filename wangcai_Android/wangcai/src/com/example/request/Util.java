package com.example.request;

import android.annotation.SuppressLint;
import org.json.JSONException;
import org.json.JSONObject;

public class Util {
	
	public static int ReadJsonInt(JSONObject jsonObj, String strKey) {
		try {
			return jsonObj.getInt(strKey);
		} catch (JSONException e) {
			return 0;
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

}
