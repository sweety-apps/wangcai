package com.coolstore.wangcai.dialog;

import android.app.AlertDialog;
import android.app.Dialog;

import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;

public class HintLoginErrorDialog  extends ManagedDialog{

	public HintLoginErrorDialog(ManagedDialogActivity owner, String strMsg) {
		super(owner);
		m_strMsg = strMsg;
	}

	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		builder.setTitle(R.string.app_description);
		builder.setMessage(m_strMsg);
		builder.setPositiveButton(R.string.exit_text, this);
		AlertDialog dlg = builder.create();
		return dlg;
	}
	
	public void Prepare(Dialog dlg) {
		
	}
	
	String m_strMsg;
}