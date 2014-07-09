package com.coolstore.wangcai.ctrls;

import com.coolstore.wangcai.R;
import com.coolstore.common.ViewHelper;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class MyWangcaiItem 
{
	public MyWangcaiItem()  {
		m_viewRoot = null;
	}

	public ViewGroup Create(Context context, boolean bLock, int nLevel, int nIconId, String strLevelName, String strLevelBenefit) {
		LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		m_viewRoot = (ViewGroup)inflater.inflate(R.layout.ctrl_my_wangcai_item,null);
		InitView(context, bLock, nLevel, nIconId, strLevelName, strLevelBenefit);
		return m_viewRoot;
	}
	
	public void SetVisibility(int nVisibility) {
		if (m_viewRoot != null) {
			m_viewRoot.setVisibility(nVisibility);
		}
	}
	public View GetView() {
		return m_viewRoot;
	}
	
	private void InitView(Context context, boolean bLock, int nLevel, int nIconId, String strLevelName, String strLevelBenefit) {
		ViewHelper.SetIconId(m_viewRoot, R.id.logo_icon, nIconId);
		ViewHelper.SetTextStr(m_viewRoot, R.id.level_name, strLevelName);

		String strText = String.format(context.getString(R.string.unlock_at_level), nLevel);
		ViewHelper.SetTextStr(m_viewRoot, R.id.unlock_level, strText);
		ViewHelper.SetTextStr(m_viewRoot, R.id.level_benefit, strLevelBenefit);
		if (bLock) {
			m_viewRoot.findViewById(R.id.lock_icon).setVisibility(View.VISIBLE);
		}
	}
	
	
	private ViewGroup m_viewRoot;
}


