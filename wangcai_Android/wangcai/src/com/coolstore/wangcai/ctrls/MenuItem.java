package com.coolstore.wangcai.ctrls;

import com.coolstore.wangcai.R;
import com.coolstore.common.ViewHelper;

import android.content.Context;
import android.view.ViewGroup;

public class MenuItem extends ItemBase
{
	public MenuItem(String strItemName) {
		super(strItemName);
	}

	public ViewGroup Create(Context context, int nIconId, String strText) {
		super.CreateView(context, R.layout.ctrl_menu_item);
		InitView(nIconId, strText);
		return m_viewRoot;
	}
	

	
	private void InitView(int nIconId, String strText) {
		ViewHelper.SetIconId(m_viewRoot, R.id.option_item_icon, nIconId);
		ViewHelper.SetTextStr(m_viewRoot, R.id.option_item_text, strText);
	}
}


