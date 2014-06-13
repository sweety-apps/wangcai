package com.coolstore.wangcai.ctrls;

import com.coolstore.common.ViewHelper;
import com.coolstore.wangcai.R;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.ToggleButton;

public class SettingItem {
	public View Create(Context context, int nIconId, String strTitle, String strText, boolean bShowToggleButton) {

		LayoutInflater inflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		m_viewRoot = (ViewGroup)inflater.inflate(R.layout.ctrl_setting_item, null);
		
		ViewHelper.SetIconId(m_viewRoot, R.id.icon, nIconId);
		ViewHelper.SetTextStr(m_viewRoot, R.id.title, strTitle);
		ViewHelper.SetTextStr(m_viewRoot, R.id.sub_text, strText);
		m_viewRoot.findViewById(R.id.on_off).setVisibility(bShowToggleButton ? View.VISIBLE : View.GONE);
		return m_viewRoot;
	}
	
	public void SetSubTextColor(int nColor) {
		((TextView)(m_viewRoot.findViewById(R.id.sub_text))).setTextColor(nColor);
	}
	public void SetButtonCheck(boolean bCheck) {
		ToggleButton button = ((ToggleButton)(m_viewRoot.findViewById(R.id.on_off)));	
		button.setChecked(bCheck);
	}
	public boolean GetButtonCheck() {
		ToggleButton button = ((ToggleButton)(m_viewRoot.findViewById(R.id.on_off)));	
		if (button.getVisibility() != View.VISIBLE) {
			return false;
		}
		return button.isChecked();		
	}
	public View GetTextView() {
		return m_viewRoot.findViewById(R.id.sub_text);
	}
	private View m_viewRoot = null;
}
