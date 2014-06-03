package com.coolstore.wangcai.base;

import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;

public class WangcaiActivity extends Activity implements WangcaiApp.WangcaiAppEvent{
	@Override  
	protected void onCreate(Bundle savedInstanceState) {  
		super.onCreate(savedInstanceState); 
		ActivityRegistry.GetInstance().PushActivity(this);
		
        WangcaiApp.GetInstance().AddEventLinstener(this);
	}  

    @Override 
    protected void onDestroy() {
        WangcaiApp.GetInstance().RemoveEventLinstener(this);

    	super.onDestroy();
    	ActivityRegistry.GetInstance().PopActivity(this);
    }	
    protected void onPause() {
    	WangcaiApp.GetInstance().SetForceGround(false);
    	m_bVisible = false;
		super.onPause();
	}
	protected void onResume() {
		WangcaiApp.GetInstance().SetForceGround(true);
		m_bVisible = true;
		super.onResume();
	}
	public boolean IsVisible() {
		return m_bVisible;
	}
	public void OnLoginComplete(int nResult, String strMsg) {
	}
	public void OnUserInfoUpdate() {
	}
	public void OnBalanceUpdate(int nCurrentBalance, int nNewBalance) {
	}
	public void OnGetAppAward(int nAward) {
		m_winNewAward = ActivityHelper.ShowNewArawdWin(this, getWindow().getDecorView(), getString(R.string.new_app_award_tip_title), nAward);
		m_winNewAward.setOnDismissListener(new OnDismissListener() {
			@Override
			public void onDismiss() {				
				m_winNewAward = null;
			}
		});
	}
	public void OnLevelUpgrate(int nLevelChanged) {
	}
	
	protected boolean m_bVisible = false;
	private PopupWindow m_winNewAward = null;
}
