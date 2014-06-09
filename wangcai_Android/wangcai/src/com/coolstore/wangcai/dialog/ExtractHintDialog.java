package com.coolstore.wangcai.dialog;

import android.app.AlertDialog;
import android.app.Dialog;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;

public class ExtractHintDialog extends ManagedDialog {

	public ExtractHintDialog(ManagedDialogActivity owner) {
		super(owner);
	}

	@Override
	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		if (Util.IsEmptyString(m_strTitle)) {
			builder.setTitle(R.string.app_description);
		}
		else {
			builder.setTitle(m_strTitle);
		}
		
		LayoutInflater inflater = LayoutInflater.from(m_ownerActivity);
		View viewLayout = inflater.inflate(R.layout.dialog_extract, null);
		ViewHelper.SetTextStr(viewLayout, R.id.account, m_strAccountText);
		ViewHelper.SetTextStr(viewLayout, R.id.money, m_strMoneyText);
		builder.setView(viewLayout);

		builder.setPositiveButton(m_ownerActivity.getString(R.string.confirm_extract), null);
	    builder.setNegativeButton(m_ownerActivity.getString(R.string.cancel_text), null);
		AlertDialog dlg = builder.create();
		return dlg;
	}
	
	public void SetInfo(String strAccoutText, String strMoneyText) {
		m_strAccountText = strAccoutText;
		m_strMoneyText = strMoneyText;
	}

	@Override
	public void Prepare(Dialog dlg) {
		// TODO Auto-generated method stub
		
	}

	private String m_strTitle;
	private String m_strAccountText;
	private String m_strMoneyText;
}
