package com.coolstore.wangcai.base;

import com.coolstore.common.IdGenerator;

import android.app.Dialog;
import android.util.SparseArray;

public class ManagedDialogActivity extends WangcaiActivity{

	@Override
	protected Dialog onCreateDialog(int nId) {
		ManagedDialog dlg = m_listDialogs.get(nId);
 		if (dlg == null) {
 			return null;
 		}
		return dlg.Create();
	}
	
	@Override
	protected void onPrepareDialog(int nId, Dialog dlg) {
		ManagedDialog managedDlg = m_listDialogs.get(nId);
 		if (managedDlg == null) {
 			return ; 
 		}
		managedDlg.Prepare(dlg);
	}
	
	public void OnDialogFinish(ManagedDialog dlg, int nViewId) {
		
	}
	
	public void RegisterDialog(ManagedDialog dlg) {
		dlg.SetId(IdGenerator.NewId());
		m_listDialogs.put(dlg.GetDialogId(), dlg);
	}
	protected SparseArray<ManagedDialog> m_listDialogs = new SparseArray<ManagedDialog>();
}
