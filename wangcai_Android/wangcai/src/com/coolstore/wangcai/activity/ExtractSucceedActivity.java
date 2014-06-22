package com.coolstore.wangcai.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

import com.coolstore.common.ViewHelper;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.TitleCtrl;

public class ExtractSucceedActivity extends WangcaiActivity{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
    	super.onCreate(savedInstanceState);
    	
    	setContentView(R.layout.activity_extract_succeed);
    	
    	Intent intent = getIntent();
    	String strTitle = intent.getStringExtra(ActivityHelper.sg_strTitle);
    	TitleCtrl title = (TitleCtrl)findViewById(R.id.title);
    	title.SetTitle(strTitle);
    	
    	final String strOrderId = intent.getStringExtra(ActivityHelper.sg_strOrderId);
    	ViewHelper.SetTextStr(this, R.id.order_number, strOrderId);
    	findViewById(R.id.order_number).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				ActivityHelper.ShowOrderDetailActivity(ExtractSucceedActivity.this, strOrderId);
			}
    		
    	});
    	
    	findViewById(R.id.exit_button).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {		
				ExtractSucceedActivity.this.finish();
			}    	
    	});
    }
}
