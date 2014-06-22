package com.coolstore.wangcai.activity;


import com.coolstore.common.BuildSetting;
import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;
import com.coolstore.wangcai.dialog.CommonDialog;
import com.coolstore.wangcai.dialog.HintLoginErrorDialog;
import com.coolstore.wangcai.dialog.HintNetwordErrorDialog;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.ImageView;

public class StartupActivity extends ManagedDialogActivity {
	

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		
        if (BuildSetting.sg_bUseFormatServer) {
        	Config.Initlialize(Config.EnvType.EnvType_Formal);
        }
        else {
        	Config.Initlialize(Config.EnvType.EnvType_Dev);
        }
    	//Config.Initlialize(Config.EnvType.EnvType_Formal);
        setContentView(R.layout.activity_startup);

        WangcaiApp app = WangcaiApp.GetInstance();
        app.Initialize(this.getApplicationContext());

        app.Login();

    	ImageView image = (ImageView) findViewById(R.id.loading);
    	image.setBackgroundResource(R.anim.ani_loading);
    	m_loadingAnimationDrawable = (AnimationDrawable)  image.getBackground(); 
    	image.setVisibility(View.VISIBLE);
    	
    	Handler handler = new Handler();   
    	handler.postDelayed(new Runnable() { 
            public void run() { 
            	ShowLoading(true);
            } 
        }, 50);
     }
    
    
    public void OnLoginComplete(int nResult, String strMsg) {
    	ShowLoading(false);

    	findViewById(R.id.loading).setVisibility(View.GONE);
    	
        WangcaiApp app = WangcaiApp.GetInstance();
    	if (nResult == 0) {
    		if (app.NeedForceUpdate()) {
    			//强制升级

    			if (m_appUpdateDialog == null) {
    				m_appUpdateDialog = new CommonDialog(this);
    				RegisterDialog(m_appUpdateDialog);
    			}
    			m_appUpdateDialog.SetInfo(getString(R.string.app_name), getString(R.string.hint_update_wangcai), 
    					getString(R.string.app_update_hint_title), null);
    			m_appUpdateDialog.Show();	
    		}else {
    			app.Init3rdSdk();
   
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
		int nDlgId = dlg.GetDialogId();
		if (m_hintNetworkErrorDialog != null && nDlgId == m_hintNetworkErrorDialog.GetDialogId()) {
			//重新登录
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
		        WangcaiApp app = WangcaiApp.GetInstance();
		        app.Login();
				ShowLoading(true);
			}
		}
		else if (m_hintLoginErrorDialog != null && nDlgId == m_hintLoginErrorDialog.GetDialogId()) {
			//绑定手机
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				finish();
			}
		}
		else if (m_appUpdateDialog != null && nDlgId == m_appUpdateDialog.GetDialogId()) {
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				String strUpdateUrl = String.format("%s&sysVer=%s", Config.GetLiveUpdateUrl(), BuildSetting.sg_strVersion);
			
				Intent intent = new Intent();        
				intent.setAction("android.intent.action.VIEW");    
				Uri contentUrl = Uri.parse(strUpdateUrl);   
				intent.setData(contentUrl);  
				startActivity(intent);
			}
		}
	}
	private void ShowLoading(boolean bShow) {
		if (bShow) {
        	m_loadingAnimationDrawable.stop();
			m_loadingAnimationDrawable.start();
		}
		else {
        	m_loadingAnimationDrawable.stop();
		}
	}

    private CommonDialog m_appUpdateDialog = null;
	private AnimationDrawable m_loadingAnimationDrawable = null;
    private HintNetwordErrorDialog m_hintNetworkErrorDialog = null;
    private HintLoginErrorDialog m_hintLoginErrorDialog = null;
}
