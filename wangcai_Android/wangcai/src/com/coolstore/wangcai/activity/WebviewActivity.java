package com.coolstore.wangcai.activity;

import java.net.URLDecoder;

import com.coolstore.common.Config;
import com.coolstore.common.SystemInfo;
import com.coolstore.common.Util;
import com.coolstore.request.UserInfo;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.ManagedDialogActivity;
import com.coolstore.wangcai.ctrls.TitleCtrl;
import com.coolstore.wangcai.dialog.CommonDialog;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;

 public class WebviewActivity extends ManagedDialogActivity {
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
    	SetTitle(strTitle);
    	
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
    protected boolean SetTitle(String strTitle) {
    	if (!Util.IsEmptyString(strTitle)) {
    		TitleCtrl ctrl = (TitleCtrl)findViewById(R.id.title);
    		ctrl.SetTitle(strTitle);
    		return true;
    	}    	
    	else {
    		return false;
    	}
    }
    protected boolean SetUrl(String strUrl) {
    	if (!Util.IsEmptyString(strUrl)) {
    		m_strUrl = strUrl;
    		m_webView.loadUrl(m_strUrl);
    		
    	  	Handler handler = new Handler();   
        	handler.postDelayed(new Runnable() { 
                public void run() { 
                	ShowView(WebviewActivity.ViewState.ViewState_Loading);
                } 
            }, 50);
    		return true;
    	}    	
    	else {
    		return false;
    	}
    }
    private void InitWebView() {
    	m_webView = (WebView)this.findViewById(R.id.web_view);
    	m_webView.addJavascriptInterface(this, "ViewObject");

    	//m_webView.getSettings().setAppCacheEnabled(false);
    	m_webView.getSettings().setJavaScriptEnabled(true);
    	m_webView.addJavascriptInterface(this, "android");
    	
    	m_webView.setWebChromeClient(new WebChromeClient() {
    	
    	});
    	m_webView.setWebViewClient(new WebViewClient(){     
    		//called by the network thread
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
            	if (OnNavigate(url)) {
            		return true;
            	}
            	m_strUrl = url;
                view.loadUrl(url); 
                return true;       
            }
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
            }
            public void onPageFinished(WebView view, String url) {    	
            	Handler handler = new Handler();   
	        	handler.postDelayed(new Runnable() { 
	                public void run() { 
	        	    	NotifyPhoneStatus();
	        	    	NotifyUserInfo();
	        	    	NotifyDeviceInfo();	 
	        	    	//m_webView.loadUrl("javascript:test()");    
	                } 
	            }, 10);	
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
    	String strUrl = intent.getStringExtra(ActivityHelper.sg_strUrl);
    	SetUrl(strUrl);
    }
    protected String GetUrlKeyValue(String strUrl, String strKeyName) {
    	strKeyName += "=";
    	//final String strKeyName= "context=";
    	int nPos = strUrl.indexOf(strKeyName);
    	if (nPos < 0) {
    		return "";
    	}
    	nPos += strKeyName.length();
    	int nEndPos = strUrl.indexOf("&", nPos);
    	if (nEndPos < 0) {
    		nEndPos = strUrl.length();
    	} 	
    	String strContent = strUrl.substring(nPos, nEndPos);;
    	return URLDecoder.decode(strContent);
    }
    @SuppressLint("NewApi") protected boolean OnNavigate(String strUrl) {
    	WangcaiApp app = WangcaiApp.GetInstance();
    	UserInfo userInfo = app.GetUserInfo();
	    if (strUrl.contains("/wangcai_js/query_attach_phone")) {
	    	NotifyPhoneStatus();
	        return true;
	    } 
	    else if (strUrl.contains("/wangcai_js/query_balance")) {
	        // 把钱的信息返回给页面
	    	NotifyUserInfo();
	        return true;
	    }
	    else if (strUrl.contains("/wangcai_js/query_device_info")) {
	        // 查询设备信息
	    	NotifyDeviceInfo();	        
	        return true;
	    }
	    else if (strUrl.contains("/wangcai_js/attach_phone")) {
	        // 点击了绑定手机
	        ActivityHelper.ShowRegisterActivity(this);	
	        return true;
	    } 
	    else if (strUrl.contains("/wangcai_js/order_info")) {
	    	String strOrderId = GetUrlKeyValue(strUrl, "num");
	    	ActivityHelper.ShowOrderDetailActivity(this, strOrderId);
	        return true;
	    } 
	    else if (strUrl.contains("/wangcai_js/copy_to_clip")) {
	    	String strContent = GetUrlKeyValue(strUrl, "context");
	    	if (Util.IsEmptyString(strContent)) {
	    		return true;
	    	}
    		ClipboardManager clipboardManager = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);  
    		clipboardManager.setPrimaryClip(ClipData.newPlainText(null, strContent));  
    		ActivityHelper.ShowToast(this, R.string.copy_succeed);
	        return true;
	    }
	    else if (strUrl.contains("/wangcai_js/open_url_inside")) {
	        String strNextUrl = GetUrlKeyValue(strUrl, "url");
	        if (Util.IsEmptyString(strUrl)) {
	        	return true;
	        }
	        String strTitle = GetUrlKeyValue(strUrl, "title");
	        
	        ActivityHelper.ShowWebViewActivity(this, strTitle, strNextUrl);	        
	        return true;
	    } 
	    else if (strUrl.contains("/wangcai_js/exchange_info")) {
	    	ActivityHelper.ShowDetailActivity(this);	        
	        return true;
	    } 
	    else if (strUrl.contains("/wangcai_js/alert")) {
	        String strTitle = GetUrlKeyValue(strUrl, "title");
	        String strInfo = GetUrlKeyValue(strUrl, "info");
	        String strButton1Text = GetUrlKeyValue(strUrl, "btntext");
	        String strButton2Text = GetUrlKeyValue(strUrl, "btn2");
	        
	        m_alertDialog = new CommonDialog(this);
			RegisterDialog(m_alertDialog);
	        m_alertDialog.SetInfo(strTitle, strInfo, strButton1Text, strButton2Text);
	        m_alertDialog.Show();
	        return true;
	    }
	    else if (strUrl.contains("/wangcai_js/service_center")) {
	        String strPhoneNumber = userInfo.GetPhoneNumber();

	        String strNextUrl = String.format("%s?mobile=%s&mobile_num=%s---%s", 
	        		Config.GetServiceCenterUrl(), 
	        		strPhoneNumber, 
	        		SystemInfo.GetMacAddress(),
	        		SystemInfo.GetImei());
	        //NSString* url = [[NSString alloc] initWithFormat:@"%@?mobile=%@&mobile_num=%@---%@",
	        //                 HTTP_SERVICE_CENTER, num, [Common getMACAddress], [Common getIDFAAddress] ];
	        ActivityHelper.ShowWebViewActivity(this, "客户服务", strNextUrl);
	        return true;
	    }  
	    else if (strUrl.contains("/wangcai_js/alert_loading")) {
	        String strShow = GetUrlKeyValue(strUrl, "show");
	        m_loadingDialog = ActivityHelper.ShowLoadingDialog(this);
	        if (strShow.equals("1")) {
	            String strText = GetUrlKeyValue(strUrl, "info");
		        m_loadingDialog = ActivityHelper.ShowLoadingDialog(this, strText);
		        
	        } else {
	        	if (m_loadingDialog != null) {
	        		m_loadingDialog.dismiss();
	        	}
	        }
	        return true;
	    }
	    
	    return false;
    }
    private void NotifyPhoneStatus() {
    	WangcaiApp app = WangcaiApp.GetInstance();
    	UserInfo userInfo = app.GetUserInfo();
		if (userInfo == null) {
			return ;
		}
        // 查询手机是否已经绑定
    	boolean bHasBindPhone = userInfo.HasBindPhone();
    	String strPhoneNumber = userInfo.GetPhoneNumber();
    	if (strPhoneNumber == null) {
    		strPhoneNumber = "";
    	}
    	float fBalance = (float)userInfo.GetBalance() / 100.0f;

        //js = [NSString stringWithFormat:@"notifyPhoneStatus(true, \"%@\", %.2f)", phone, banlance];
    	String strJsFunction = String.format("javascript:notifyPhoneStatus(%b, \"%s\", %.2f)", 
    			bHasBindPhone, strPhoneNumber, fBalance);
    	m_webView.loadUrl(strJsFunction);    	
    }
    private void NotifyUserInfo() {
    	WangcaiApp app = WangcaiApp.GetInstance();
    	UserInfo userInfo = app.GetUserInfo();

    	float fBalance = (float)userInfo.GetBalance() / 100.0f;
    	float fIncome = (float)userInfo.GetTotalIncome() / 100.0f;
    	float fOutgo = (float)userInfo.GetTotalOutgo() / 100.0f;
    	float fShareIncome = (float)userInfo.GetShareIncome() / 100.0f;

        //NSString* js = [NSString stringWithFormat:@"notifyBalance(%.2f, %.2f, %.2f, %.2f)",
        //                1.0*balance/100, 1.0*income/100, 1.0*outgo/100, 1.0*sharedIncome/100];
    	String strJsFunction = String.format("javascript:notifyBalance(%.2f, %.2f, %.2f, %.2f)", 
    			fBalance, fIncome, fOutgo, fShareIncome);
    	m_webView.loadUrl(strJsFunction);    	
    }
    public void NotifyDeviceInfo() {
    	WangcaiApp app = WangcaiApp.GetInstance();
    	UserInfo userInfo = app.GetUserInfo();

    	String strDeviceId = userInfo.GetDeviceId();
    	String strSessionId = userInfo.GetSessionId();
    	String strUserId = String.valueOf(userInfo.GetUserId());

        //NSString* js = [NSString stringWithFormat:@"notifyDeviceInfo(\"%@\", \"%@\", %@)", device, sessionId, userid];
    	String strJsFunction = String.format("javascript:notifyDeviceInfo(\"%s\", \"%s\", \"%s\")", 
    			strDeviceId, strSessionId, strUserId);
    	m_webView.loadUrl(strJsFunction);
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

    private CommonDialog m_alertDialog = null;
    private ProgressDialog m_loadingDialog = null;
    private WebView m_webView;
    private String m_strUrl;
	private AnimationDrawable m_loadingAnimationDrawable;
}
