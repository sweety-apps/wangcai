package com.example.wangcai;

import android.app.AlertDialog;
import android.app.Dialog;

public class BindPhoneDialog extends ManagedDialog{

	public BindPhoneDialog(ManagedDialogActivity owner) {
		super(owner);
	}

	public Dialog Create() {
		AlertDialog.Builder builder = new AlertDialog.Builder(m_ownerActivity);
		builder.setTitle(R.string.app_description);
		builder.setMessage(R.string.hint_bind_phone);
		builder.setPositiveButton(R.string.bind_phone, this);
		builder.setNegativeButton(R.string.cancel, this);
		AlertDialog dlg = builder.create();
		return dlg;
	}
	
	public void Prepare(Dialog dlg) {
		
	}
	
}
