package com.coolstore.wangcai.base;

import cn.jpush.android.api.JPushInterface;

import com.coolstore.common.LogUtil;
import com.coolstore.wangcai.ConfigCenter;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;

import android.app.Activity;
import android.os.Bundle;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;

public class WangcaiActivity extends Activity implements WangcaiApp.WangcaiAppEvent{
	private final static int sg_nInvlidLevelChanged = -99999;
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

    	JPushInterface.onPause(this);
		super.onPause();
	}
	protected void onResume() {
		WangcaiApp app = WangcaiApp.GetInstance();
		app.SetForceGround(true);
		app.SetLastActivity(this);
		m_bVisible = true;
    	JPushInterface.onResume(this);
    	int nPendingPurse = app.GetPendingPurse();
		LogUtil.LogNewPurse("onResume PendindPurse(%d)", nPendingPurse);
    	if (nPendingPurse > 0) {
			ShowPurseTip(nPendingPurse); 
			app.ResetPendingPurse();
    	}
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
	public boolean OnGetAppAward(int nAward) {
		LogUtil.LogNewPurse("OnGetAppAward (%d)  m_bVisible(%b)", nAward, m_bVisible);
		if (m_bVisible) {
			ShowPurseTip(nAward);
			return true;
		}
		else {
			return false;
		}
	}
	private void ShowPurseTip(int nAward) {
		m_winNewAward = ActivityHelper.ShowNewArawdWin(this, getWindow().getDecorView(), getString(R.string.new_app_award_tip_title), nAward);
		m_winNewAward.setOnDismissListener(new OnDismissListener() {
			@Override
			public void onDismiss() {				
				m_winNewAward = null;
				if (m_nLevelChange != sg_nInvlidLevelChanged) {
					ActivityHelper.ShowLevelUpgrateWin(WangcaiActivity.this, getWindow().getDecorView(), GetCurrentLevel(), m_nLevelChange);
					m_nLevelChange = sg_nInvlidLevelChanged;
				}
			}
		});

    	if (ConfigCenter.GetInstance().ShouldPlaySound()) {
    		WangcaiApp.GetInstance().PlaySound();
    	}
	}
	private int GetCurrentLevel() {
		return WangcaiApp.GetInstance().GetUserInfo().GetCurrentLevel();
	}
	public void OnLevelChanged(int nLevel, int nLevelChange) {
		if (m_winNewAward == null) {
			ActivityHelper.ShowLevelUpgrateWin(this, getWindow().getDecorView(), GetCurrentLevel(), nLevelChange);
		}
		else {
			m_nLevelChange = nLevelChange;
		}
	}
	public void OnLevelUpgrate(int nLevelChanged) {
	}
	
	protected boolean m_bVisible = false;
	private PopupWindow m_winNewAward = null;
	private int m_nLevelChange = sg_nInvlidLevelChanged;
}
