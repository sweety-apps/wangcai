package com.coolstore.wangcai.activity;

import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.SettingItem;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
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
    	
    	CreateItem(viewParent, R.drawable.setting_message, getString(R.string.setting_push_title), getString(R.string.setting_push_text), true);
    	
    	CreateItem(viewParent, R.drawable.setting_bell, getString(R.string.setting_sournd_title), getString(R.string.setting_sournd_text), true);
  	
    	SettingItem item = CreateItem(viewParent, R.drawable.about2, getString(R.string.setting_version_title), getString(R.string.setting_version_text), true);
    	item.SetSubTextColor(Color.rgb(28, 28, 255));
    }
    
    private SettingItem CreateItem(ViewGroup viewParent, int nIconId, String strTitle, String strText, boolean bShowToggleButton) {
    	SettingItem item = new SettingItem();
    	View itemView = item.Create(this, nIconId, strTitle, strText, bShowToggleButton);
    	viewParent.addView(itemView);
    	return item;
    }
}
