package com.coolstore.wangcai.base;

import java.util.ArrayList;

import android.app.Activity;

public class ActivityRegistry {
	private static ActivityRegistry m_obj = new ActivityRegistry();

	public static ActivityRegistry GetInstance() {
		return m_obj;
	}
	
	public void PushActivity(WangcaiActivity activity) {
		m_stackActivity.add(activity);
	}
	
	public boolean PopActivity(WangcaiActivity activity) {
		return m_stackActivity.remove(activity);
	}
	
	public boolean Remove(int nIndex) {
		if (nIndex < 0 || nIndex >= m_stackActivity.size()) {
			return false;
		}
		m_stackActivity.remove(nIndex);
		return true;
	}
	
	public WangcaiActivity GetTopActivity() {
		if (m_stackActivity.isEmpty()) {
			return null;
		}
		return m_stackActivity.get(m_stackActivity.size() - 1);
	}
	public int GetActivityCount() {
		return m_stackActivity.size();
	}
	
	public Activity GetActivity(int nIndex) {
		if (nIndex < 0 || nIndex >= m_stackActivity.size()) {
			return null;
		}
		return m_stackActivity.get(nIndex);
	}

	private ArrayList<WangcaiActivity> m_stackActivity = new ArrayList<WangcaiActivity>();
}
