package com.coolstore.wangcai;


import com.coolstore.common.Util;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Environment;
import android.text.format.Time;

public class ConfigCenter {
	private final static String sg_strConfigName = "WangcaiConfig";
	private final static String sg_strLastSignInDate = "LastSignInDate";
	private final static String sg_strHasClickMenu = "HasClickMenu";
	private final static String sg_strShouldReceiveMsg = "ShouldReceiveMsg";
	private final static String sg_strShouldPlaySound = "ShouldPlaySound";
	private final static String sg_strLastBalance = "LastBalance";
	private final static String sg_strHasShowRiskHint = "HasShowRiskHint";
	
	interface ConfigCenterEvent {
		
	}
	
	private static ConfigCenter sg_Object = null;
	public static ConfigCenter GetInstance() {
		if (sg_Object == null) {
			sg_Object = new ConfigCenter();
		}
		return sg_Object;
	}
	public void Initialize(Context context) {
		m_sharedPreference = context.getSharedPreferences(sg_strConfigName, Context.MODE_PRIVATE);
	}
	
	@SuppressLint("DefaultLocale") private String GetCurrentDateString() {
		Time time = new Time();
		time.setToNow(); 
		return String.format("%d%d", time.year, time.yearDay);
	}
	
	public void SetHasSignInToday() {
		Editor editor = m_sharedPreference.edit();
		String strCurrentDate = GetCurrentDateString();
		editor.putString(sg_strLastSignInDate, strCurrentDate);
		editor.commit();
	}
	public boolean HasSignInToday() {
		String strLastDate =  m_sharedPreference.getString(sg_strLastSignInDate, "");
		if (Util.IsEmptyString(strLastDate)) {
			return false;
		}
		
		//上次抽奖时间
		String strCurrentDate = GetCurrentDateString();	
		return strCurrentDate.equals(strLastDate);
	}
	
	
	public boolean HasClickMenu() {
		return m_sharedPreference.getBoolean(sg_strHasClickMenu, false);
	}
	public void SetHasClickMenu(boolean bClick) {
		Editor editor = m_sharedPreference.edit();
		editor.putBoolean(sg_strHasClickMenu, bClick);
		editor.commit();		
	}
	
	public boolean ShouldReceivePush() {
		return m_sharedPreference.getBoolean(sg_strShouldReceiveMsg, true);
	}
	public void SetShouldReceivePush(boolean bReceive) {
		Editor editor = m_sharedPreference.edit();
		editor.putBoolean(sg_strShouldReceiveMsg, bReceive);
		editor.commit();
	}
	
	public boolean ShouldPlaySound() {
		return m_sharedPreference.getBoolean(sg_strShouldPlaySound, true);		
	}
	public void SetShouldPlaySound(boolean bPlay) {
		Editor editor = m_sharedPreference.edit();
		editor.putBoolean(sg_strShouldPlaySound, bPlay);
		editor.commit();
	}
	
	public void SetLastBalance(int nBalance) {
		Editor editor = m_sharedPreference.edit();
		editor.putInt(sg_strLastBalance, nBalance);
		editor.commit();		
	}
	public int GetLastBalance() {
		return m_sharedPreference.getInt(sg_strLastBalance, -1);	
	}
	
	public String GetCachePath() {
		return Environment.getExternalStorageDirectory().getAbsolutePath() + "/com.coolstore.wangcai";
	}

	public boolean HasShowRiskHint() {
		return m_sharedPreference.getBoolean(sg_strHasShowRiskHint, false);		
	}
	public void SetHasShowRiskHint() {
		Editor editor = m_sharedPreference.edit();
		editor.putBoolean(sg_strHasShowRiskHint, true);
		editor.commit();
	}
	
	
	private SharedPreferences m_sharedPreference = null; 
}
