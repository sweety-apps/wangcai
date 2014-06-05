package com.coolstore.wangcai.activity;

import com.coolstore.common.Util;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.TitleCtrl;

import android.content.Intent;
import android.os.Bundle;
import android.webkit.WebView;

 public class WebviewActivity extends WangcaiActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_web);
        
        InitView();
     }


    private void InitView() {
	   	WebView webView = (WebView)this.findViewById(R.id.web_view);
	   	webView.addJavascriptInterface(this, "ViewObject");
	   	
    	Intent intent = getIntent();
    	
    	String strTitle = intent.getStringExtra(ActivityHelper.sg_strTitle);
    	if (!Util.IsEmptyString(strTitle)) {
    		TitleCtrl ctrl = (TitleCtrl)findViewById(R.id.title);
    		ctrl.SetTitle(strTitle);
    	}
    	
    	String strUrl = intent.getStringExtra(ActivityHelper.sg_strUrl);
    	if (!Util.IsEmptyString(strUrl)) {
        	webView.loadUrl(strUrl);
    	}
    	
    	
    }

    
}
