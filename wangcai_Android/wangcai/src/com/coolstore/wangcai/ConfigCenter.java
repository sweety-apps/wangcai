package com.coolstore.wangcai;

import java.lang.ref.WeakReference;
import java.util.ArrayList;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.text.format.Time;

public class ConfigCenter {
	private final static String sg_strConfigName = "WangcaiConfig";
	private final static String sg_strHasSignInKey = "HasSignIn";
	private final static String sg_strHasClickMenu = "HasClickMenu";
	private final static String sg_strShouldReceiveMsg = "ShouldReceiveMsg";
	private final static String sg_strShouldPlaySound = "ShouldPlaySound";
	
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
	public void SetHasSignInToday() {
		Editor editor = m_sharedPreference.edit();
		editor.putString(sg_strHasSignInKey, String.valueOf(System.currentTimeMillis()));
		editor.commit();
	}
	public boolean HasSignInToday() {
		String strTime =  m_sharedPreference.getString(sg_strHasSignInKey, "0");
		
		//上次抽奖时间
		long nLastTime  = Long.parseLong(strTime);	

		Time time = new Time();

		long nCurrentTime = time.toMillis(false);

		long nDif = (time.hour * 3600 + time.minute * 60 + time.second) * 1000;
		long nTodayBeginTime = nCurrentTime - nDif;		//今天0点0分的时间
		return nLastTime < nTodayBeginTime || nLastTime > nCurrentTime;
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
	
	private SharedPreferences m_sharedPreference;
	private ArrayList<WeakReference<ConfigCenterEvent>> m_listEventListener = new ArrayList<WeakReference<ConfigCenterEvent>>(); 
}
