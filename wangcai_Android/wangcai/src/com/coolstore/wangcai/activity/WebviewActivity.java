package com.coolstore.wangcai.activity;

import com.coolstore.common.Util;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.TitleCtrl;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;

 public class WebviewActivity extends WangcaiActivity {
	 enum ViewState {
		 ViewState_Loading,
		 ViewState_Succeed,
		 ViewState_Fail
	 }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_web);
        
        InitView();
     }


    private void InitView() {
    	Intent intent = getIntent();
    	
    	String strTitle = intent.getStringExtra(ActivityHelper.sg_strTitle);
    	if (!Util.IsEmptyString(strTitle)) {
    		TitleCtrl ctrl = (TitleCtrl)findViewById(R.id.title);
    		ctrl.SetTitle(strTitle);
    	}
    	
    	ImageView image = (ImageView) findViewById(R.id.loading);
    	image.setBackgroundResource(R.anim.ani_loading);
    	m_loadingAnimationDrawable = (AnimationDrawable)  image.getBackground(); 
    	image.setVisibility(View.VISIBLE);
    	
    	findViewById(R.id.retry).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				m_webView.loadUrl(m_strUrl);   
            	ShowView(WebviewActivity.ViewState.ViewState_Loading);   
			}
    	
    	});
    	
    	InitWebView();
    }
    
    private void InitWebView() {
    	m_webView = (WebView)this.findViewById(R.id.web_view);
    	m_webView.addJavascriptInterface(this, "ViewObject");
	  
    	m_webView.setWebViewClient(new WebViewClient(){     
    		//called by the network thread
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
            	m_strUrl = url;
                view.loadUrl(url); 
                return true;       
            }
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
            }
            public void onPageFinished(WebView view, String url) {
            	ShowView(WebviewActivity.ViewState.ViewState_Succeed);
            }
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                return null;
            }
            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            	ShowView(WebviewActivity.ViewState.ViewState_Fail);
            }
	   	});       	

    	Intent intent = getIntent();
    	m_strUrl = intent.getStringExtra(ActivityHelper.sg_strUrl);
    	if (!Util.IsEmptyString(m_strUrl)) {
    		m_webView.loadUrl(m_strUrl);
    		
    	  	Handler handler = new Handler();   
        	handler.postDelayed(new Runnable() { 
                public void run() { 
                	ShowView(WebviewActivity.ViewState.ViewState_Loading);
                } 
            }, 50);
    	}
    }
    private void ShowView(ViewState enumState) {
    	View viewLoading = findViewById(R.id.loading);
    	View viewWeb = findViewById(R.id.web_view);
    	View viewError = findViewById(R.id.error_frame);

    	m_loadingAnimationDrawable.stop();
    	
    	switch (enumState) {
    	case ViewState_Loading:
			m_loadingAnimationDrawable.start();
			viewLoading.setVisibility(View.VISIBLE);
			viewWeb.setVisibility(View.GONE);
			viewError.setVisibility(View.GONE);
    		break;
    	case ViewState_Succeed:
			viewLoading.setVisibility(View.GONE);
			viewWeb.setVisibility(View.VISIBLE);
			viewError.setVisibility(View.GONE);
    		break;
    	case ViewState_Fail:
			viewLoading.setVisibility(View.GONE);
			viewWeb.setVisibility(View.GONE);
			viewError.setVisibility(View.VISIBLE);
    		break;
    	}
    }
    private WebView m_webView;
    private String m_strUrl;
	private AnimationDrawable m_loadingAnimationDrawable;
}
