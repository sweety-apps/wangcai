package com.coolstore.wangcai.dialog;

import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;

import android.app.AlertDialog;
import android.app.Dialog;

public class HintBindPhoneDialog extends ManagedDialog{

	public HintBindPhoneDialog(ManagedDialogActivity owner) {
		super(owner);
	}

	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		builder.setTitle(R.string.app_description);
		builder.setMessage(R.string.hint_bind_phone);
		builder.setPositiveButton(R.string.bind_phone, this);
		builder.setNegativeButton(R.string.cancel_text, this);
		AlertDialog dlg = builder.create();
		return dlg;
	}
	
	public void Prepare(Dialog dlg) {
		
	}
	
}
