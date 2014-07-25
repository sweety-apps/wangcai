package com.coolstore.wangcai.dialog;

import android.app.AlertDialog;
import android.app.Dialog;
import android.view.LayoutInflater;
import android.view.View;
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
		if (!Util.IsEmptyString(m_strHintText)) {
			ViewHelper.SetTextStr(viewLayout, R.id.hint, m_strHintText);
		}
		builder.setView(viewLayout);

		if (Util.IsEmptyString(m_strPositive)) {
			builder.setPositiveButton(m_ownerActivity.getString(R.string.confirm_extract), this);
		}
		else {
			builder.setPositiveButton(m_strPositive, this);			
		}
		if (Util.IsEmptyString(m_strNevative)) {
			builder.setNegativeButton(m_ownerActivity.getString(R.string.cancel_text), this);
		}
		else {
			builder.setNegativeButton(m_strNevative, this);
		}
		AlertDialog dlg = builder.create();
		return dlg;
	}
	
	public void SetInfo(String strAccoutText, String strMoneyText) {
		m_strAccountText = strAccoutText;
		m_strMoneyText = strMoneyText;
	}
	public void SetHintText(String strHintText) {
		m_strHintText = strHintText;
	}
	public void SetButtonText(String strPositive, String strNevative) {
		m_strPositive = strPositive;
		m_strNevative = strNevative;
	}
	@Override
	public void Prepare(Dialog dlg) {
	}

	private String m_strTitle;
	private String m_strAccountText;
	private String m_strMoneyText;
	private String m_strHintText;
	private String m_strPositive;
	private String m_strNevative;
}



