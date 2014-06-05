package com.imopan.mppushsample;

import com.imopan.mppush.MopanPushMan;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		
		//
		// 初始化push，传入      appId，            appSec ; 
		// appId ，appSec 上传应用到www.imopan.com后，获取到
		MopanPushMan.getInstance(this).startMopanPush("10000", "0123456789");
		//
		
		 Button apipush = (Button) findViewById(R.id.apipush);
	        
		 apipush.setOnClickListener(new OnClickListener() {
	            
	            @Override
	            public void onClick(View v) {
	                // api方式推送一条广告
	            	MopanPushMan.getInstance(MainActivity.this).postPushAd();
	            }
	        });
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

}
