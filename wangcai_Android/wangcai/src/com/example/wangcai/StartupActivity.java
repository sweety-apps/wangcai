package com.example.wangcai;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class StartupActivity extends Activity implements WangcaiApp.WangcaiAppEvent{
	

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_startup);

        WangcaiApp app = WangcaiApp.GetInstance();
        app.Initialize(this.getApplicationContext());
        
        app.AddEventLinstener(this);
        
        app.Login();

     }
    
    public void OnLoginComplete(int nResult) {
        WangcaiApp app = WangcaiApp.GetInstance();
    	if (nResult == 0) {
    		if (app.NeedForceUpdate()) {
    			//ǿ������
    		}else {
    			//��������
    			Intent it = new Intent(StartupActivity.this, MainActivity.class);
    			startActivity(it);
    			finish();
    		}

            app.RemoveEventLinstener(this);
    	} else {
    		//��½ʧ��
    	}
    }
    public void OnUserInfoUpdate() {
    }

}
