package com.example.wangcai;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class LotteryActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lottery);

        AttachEvents();

     }
    
    private void AttachEvents()
    {
    	((Button)this.findViewById(R.id.return_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            	finish();
            }
        });
    
    	/*
    	//�齱��ť
    	((Button)this.findViewById(R.id.lottery_button)).setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
            }
        });
    	*/
    }

}