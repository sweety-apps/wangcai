package com.coolstore.wangcai.activity;


import com.coolstore.common.BuildSetting;
import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;
import com.coolstore.wangcai.dialog.HintLoginErrorDialog;
import com.coolstore.wangcai.dialog.HintNetwordErrorDialog;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

public class StartupActivity extends ManagedDialogActivity {
	

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (BuildSetting.sg_bIsDebug) {
        	Config.Initlialize(Config.EnvType.EnvType_Dev);
        }
        else {
        	Config.Initlialize(Config.EnvType.EnvType_Formal);
        }
    	//Config.Initlialize(Config.EnvType.EnvType_Formal);
        setContentView(R.layout.activity_startup);

        WangcaiApp app = WangcaiApp.GetInstance();
        app.Initialize(this.getApplicationContext());

        app.Login();

     }
    
    public void OnLoginComplete(int nResult, String strMsg) {
        WangcaiApp app = WangcaiApp.GetInstance();
    	if (nResult == 0) {
    		if (app.NeedForceUpdate()) {
    			//强制升级
    		}else {
    			//正常启动
    			Intent it = new Intent(StartupActivity.this, MainActivity.class);
    			startActivity(it);
    			finish();
    		}

            app.RemoveEventLinstener(this);
    	} else {
    		//登陆失败
    		if (Util.IsEmptyString(strMsg)) {  
    			if (m_hintNetworkErrorDialog == null) {
    				m_hintNetworkErrorDialog = new HintNetwordErrorDialog(this);
    				RegisterDialog(m_hintNetworkErrorDialog);
    			}
    			m_hintNetworkErrorDialog.Show();			
    		}
    		else {
    			if (m_hintLoginErrorDialog == null) {
    				m_hintLoginErrorDialog = new HintLoginErrorDialog(this, strMsg);
    				RegisterDialog(m_hintLoginErrorDialog);
    			}
    			m_hintLoginErrorDialog.Show();	
    		}
    	}
    	super.OnLoginComplete(nResult, strMsg);
    }
    //对话框返回
	public void OnDialogFinish(ManagedDialog dlg, int inClickedViewId) {
		if (m_hintNetworkErrorDialog != null && dlg.GetDialogId() == m_hintNetworkErrorDialog.GetDialogId()) {
			//绑定手机
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
		        WangcaiApp app = WangcaiApp.GetInstance();
		        app.Login();
			}
		}
		else if (m_hintLoginErrorDialog != null && dlg.GetDialogId() == m_hintLoginErrorDialog.GetDialogId()) {
			//绑定手机
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				finish();
			}
		}
	}
    HintNetwordErrorDialog m_hintNetworkErrorDialog;
    HintLoginErrorDialog m_hintLoginErrorDialog;
}
