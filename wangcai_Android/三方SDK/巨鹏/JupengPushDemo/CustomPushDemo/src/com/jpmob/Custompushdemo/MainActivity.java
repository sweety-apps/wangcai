package com.jpmob.Custompushdemo;




import com.jpmob.sdk.push.PushConnector;

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
		
		//  设置开发者自定义Activity , CustomActivity 在manifest.xml中定义 ,继承于JupengActivity [必须]
		PushConnector.getInstance(this).setCustomActivity( getPackageName() + ".CustomActivity");
		//  设置开发者自定义Activity , CustomActivity 在manifest.xml中定义 ,继承于JupengActivity [必须]
		PushConnector.getInstance(this).setCustomReceiver(getPackageName() + ".CustomReceiver");
		// 设置开发者自定义Activity , CustomActivity 在manifest.xml中定义 ,继承于JupengActivity [必须]
		PushConnector.getInstance(this).setCustomService(getPackageName() + ".CustomService");
		
		// 设置开发者启动服务的帐号和密码 [必须]
		PushConnector.getInstance(this).startPush("800", "800800800");
		
		// 设置push广告的显示icon [可选]
		PushConnector.getInstance(this).setPushAdIcon(R.drawable.ic_launcher);
		
		
		Button apimodepushAd = (Button) findViewById(R.id.apimodepushad);	        
		apimodepushAd.setOnClickListener(new OnClickListener() {
	            
	            @Override
	            public void onClick(View v) {
	                // api方式推送一条广告
	            	PushConnector.getInstance(MainActivity.this).apiPushAd();
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
