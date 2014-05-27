package com.example.wangcai.activity;

import android.app.ProgressDialog;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.PopupWindow;

import com.example.common.BuildSetting;
import com.example.common.Util;
import com.example.request.RequestManager;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.Requesters.Request_UpdateInviter;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.WangcaiActivity;

public class WriteInviteCodeAcitivty extends WangcaiActivity implements RequestManager.IRequestManagerCallback{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wriate_invite_code);        

        InitView();        
     }
    
    private void InitView() {
    	this.findViewById(R.id.commit_invite_code).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
            	EditText edit = (EditText)findViewById(R.id.invite_code_edit);
            	String strInviteCode = edit.getText().toString();
            	if (Util.IsEmptyString(strInviteCode)) {
            		ActivityHelper.ShowToast(WriteInviteCodeAcitivty.this, R.string.hint_invlide_invite_code);
            		return;
            	}
				RequestManager requestManager = RequestManager.GetInstance();
				Request_UpdateInviter request = (Request_UpdateInviter)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_UpdateInviter);
				request.SetInviter(strInviteCode);
				requestManager.SendRequest(request, true, WriteInviteCodeAcitivty.this);

		        m_progressDialog = ActivityHelper.ShowLoadingDialog(WriteInviteCodeAcitivty.this);
			}
    	});
    }

    private void HideProgressDialog() {
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}
    }
	@Override
	public void OnRequestComplete(int nRequestId, Requester req) {
		HideProgressDialog();
		
		if (req instanceof Request_UpdateInviter) {
			int nResult = req.GetResult();
			String strMsg = req.GetMsg();
			if (BuildSetting.sg_bIsDebug) {
				nResult = 0;
			}
			if (nResult == 0) {
        		//ActivityHelper.ShowToast(WriteInviteCodeAcitivty.this, R.string.hint_bind_invite_code_succeed);	

				PopupWindow win = ActivityHelper.ShowNewArawdWin(this, getWindow().getDecorView(), getString(R.string.invite_award_tip_title), 200);
				win.setOnDismissListener(new PopupWindow.OnDismissListener () {

					@Override
					public void onDismiss() {
						WriteInviteCodeAcitivty.this.HideProgressDialog();
						WriteInviteCodeAcitivty.this.finish();
					}
				
				});
        		WangcaiApp.GetInstance().ChangeBalance(200);

			}
			else {
				if (Util.IsEmptyString(strMsg)) {
            		ActivityHelper.ShowToast(WriteInviteCodeAcitivty.this, R.string.hint_bind_invite_code_fail);					
				}
				else {
            		ActivityHelper.ShowToast(WriteInviteCodeAcitivty.this, strMsg);					
				}
			}
		}		
	}
    private ProgressDialog m_progressDialog = null;
}
