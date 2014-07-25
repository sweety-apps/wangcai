package com.coolstore.wangcai.activity;

import cn.jpush.android.api.JPushInterface;

import com.coolstore.common.Config;
import com.coolstore.common.SystemInfo;
import com.coolstore.wangcai.ConfigCenter;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.SettingItem;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;

public class SettingActivity extends WangcaiActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting);
        
        InitView();
     }

    private void InitView()
    {
    	ViewGroup viewParent = (ViewGroup)findViewById(R.id.main_client);
    	
    	m_pushItem = CreateItem(viewParent, R.drawable.setting_message, getString(R.string.setting_push_title), getString(R.string.setting_push_text), true);
    	
    	ConfigCenter config = ConfigCenter.GetInstance();
    	m_pushItem.SetButtonCheck(config.ShouldReceivePush());
    	
    	m_soundItem = CreateItem(viewParent, R.drawable.setting_bell, getString(R.string.setting_sournd_title), getString(R.string.setting_sournd_text), true);
    	m_soundItem.SetButtonCheck(config.ShouldPlaySound());
    	
    	String strText = String.format(getString(R.string.setting_version_title), SystemInfo.GetVersion());
    	SettingItem item = CreateItem(viewParent, R.drawable.about2, strText, getString(R.string.setting_version_text), false);
    	item.SetSubTextColor(Color.rgb(28, 28, 255));
    	item.GetTextView().setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				ActivityHelper.ShowWebViewActivity(SettingActivity.this, getString(R.string.setting_version_text), Config.GetLicenseUrl());
			} 
    		
    	});
    }
    
    private SettingItem CreateItem(ViewGroup viewParent, int nIconId, String strTitle, String strText, boolean bShowToggleButton) {
    	SettingItem item = new SettingItem();
    	View itemView = item.Create(this, nIconId, strTitle, strText, bShowToggleButton);
    	viewParent.addView(itemView);
    	return item;
    }

    @Override
    protected void onPause() {
    	super.onPause();

    	ConfigCenter config = ConfigCenter.GetInstance();
    	
    	boolean bReceivePush = m_pushItem.GetButtonCheck();
    	config.SetShouldReceivePush(bReceivePush);
    	if (bReceivePush) {
			JPushInterface.resumePush(WangcaiApp.GetInstance().GetContext());    		
    	}
    	else {
			JPushInterface.stopPush(WangcaiApp.GetInstance().GetContext());    		
    	}
    	config.SetShouldPlaySound(m_soundItem.GetButtonCheck());
    }
    
    SettingItem m_pushItem = null;
    SettingItem m_soundItem = null;
}
