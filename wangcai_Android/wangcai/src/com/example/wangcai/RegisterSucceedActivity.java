package com.example.wangcai;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

public class RegisterSucceedActivity extends ManagedActivity{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register_succeed);        

        Intent intent = getIntent();
        int nBindDeviceCount = intent.getIntExtra(ActivityHelper.sg_strBindDeviceCount, 0);
		String strMsg = String.format(this.getString(R.string.bind_phone_limit_hint), nBindDeviceCount);
		ActivityHelper.ShowToast(this, strMsg);
		
		
		findViewById(R.id.go_mainpage_button).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				//·µ»ØÖ÷Ò³Ãæ
				ActivityRegistry reg = ActivityRegistry.GetInstance();
				int nCount = reg.GetActivityCount();
				for (int i = nCount - 1; i >= 0; --i) {
					Activity ac = reg.GetActivity(i);
					if (!(ac instanceof MainActivity)) {
						ac.finish();
					}
					else {
						break;
					}
				}
			}});
     }

}
