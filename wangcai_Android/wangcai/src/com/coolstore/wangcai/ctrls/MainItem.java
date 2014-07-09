package com.coolstore.wangcai.ctrls;

import com.coolstore.wangcai.R;
import com.coolstore.common.ViewHelper;

import android.content.Context;
import android.view.View;

public class MainItem extends ItemBase
{
	public MainItem(String strItemName) {
		super(strItemName);
	}

	public View Create(Context context, int nItemIconId, String strTitle, String strTip, int nMoney, Boolean bComplete) {
		super.CreateView(context, R.layout.ctrl_main_item);
		InitView(nItemIconId, strTitle, strTip, GetMoneyIconId(nMoney), bComplete);
		return m_viewRoot;
	}

	private void InitView(int nItemIconId, String strTitle, String strTip, int nMoneyIconId, Boolean bComplete) {
		ViewHelper.SetIconId(m_viewRoot, R.id.main_item_icon, nItemIconId);
		ViewHelper.SetTextStr(m_viewRoot, R.id.main_item_title, strTitle);
		ViewHelper.SetTextStr(m_viewRoot, R.id.main_item_tip, strTip);
		if (bComplete)
		{
			ViewHelper.SetChildVisibility(m_viewRoot, R.id.main_item_money_icon, View.GONE);
			ViewHelper.SetChildVisibility(m_viewRoot, R.id.main_item_task_status, View.VISIBLE);
		}
		else
		{
			ViewHelper.SetChildVisibility(m_viewRoot, R.id.main_item_task_status, View.GONE);
			ViewHelper.SetChildVisibility(m_viewRoot, R.id.main_item_money_icon, View.VISIBLE);
			ViewHelper.SetIconId(m_viewRoot, R.id.main_item_money_icon, nMoneyIconId);
		}
	}

	   private int GetMoneyIconId(int nMoney) {
		   	int nIconId = R.drawable.package_icon_many;
		   	switch (nMoney) {
		   	case 10:
		   		nIconId = R.drawable.package_icon_1mao;
		   		break;
		   	case 50:
		   		nIconId = R.drawable.package_icon_1mao;
		   		break;
		   	case 100:
		   		nIconId = R.drawable.package_icon_1;
		   		break;
		   	case 200:
		   		nIconId = R.drawable.package_icon_2;
		   		break;
		   	case 300:
		   		nIconId = R.drawable.package_icon_3;
		   		break;
		   	case 800:
		   		nIconId = R.drawable.package_icon_8;
		   		break;
		   	}
		   	return nIconId;
	   }
	
}


