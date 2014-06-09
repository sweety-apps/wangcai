package com.coolstore.wangcai.activity;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.UserInfo;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.TitleCtrl;

import android.annotation.SuppressLint;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;

public class InviteActivity extends WangcaiActivity implements RequestManager.IRequestManagerCallback, OnClickListener{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_invite);

        AttachEvents();
        InitView();
     }

    private void InitView() {
    	//二维码
    	
    	WangcaiApp app = WangcaiApp.GetInstance();
    	UserInfo userInfo = app.GetUserInfo();
    	
    	//邀请码
    	String strInvideCode = userInfo.GetInviteCode();
    	if (!Util.IsEmptyString(strInvideCode)) {
        	TextView inviteCodeView = (TextView)this.findViewById(R.id.invite_code);    		
    		inviteCodeView.setText(strInvideCode);

        	ImageView qrcodeView = (ImageView)this.findViewById(R.id.qrcode);
            
        	String strInviteUrl = String.format(Config.GetInviteUrl(), strInvideCode);
        	qrcodeView.setImageBitmap(Util.CreateQRCodeBitmap(strInviteUrl, getResources().getDimensionPixelSize(R.dimen.qrcode_size)));
    	}

    	//邀请链接
    	View view = this.findViewById(R.id.invite_url_text);;
    	TextView invateUrlView = (TextView)view;
    	m_strInviteUrl = userInfo.GetInviteUrl();
    	if (!Util.IsEmptyString(m_strInviteUrl)) {
    		invateUrlView.setText(m_strInviteUrl);
    	}
    	
    	TextView awardText = ((TextView)findViewById(R.id.friend_award));
    	String strText = String.format(getString(R.string.invite_friend_award), Util.FormatMoney(userInfo.GetShareIncome()));
    	awardText.setText(strText);
    }

    @SuppressLint("NewApi") public void onClick(View v) {
    	int nId = v.getId();
    	if (nId == R.id.copy_url_button) {
    		ClipboardManager clipboardManager = (ClipboardManager)getSystemService(Context.CLIPBOARD_SERVICE);  
    		clipboardManager.setPrimaryClip(ClipData.newPlainText(null, m_strInviteUrl));  
    		ActivityHelper.ShowToast(this, R.string.copy_succeed);
    	}
    	else if (nId == R.id.share_button) {
    		
    	}
    	else if (nId == R.id.view_detail) {
    		ActivityHelper.ShowWebViewActivity(this, getString(R.string.invite_rull_detail_title), Config.GetInviteRuleUrl());
    	    //NSString* url = [[[NSString alloc] initWithFormat:@"%@123", WEB_SERVICE_VIEW] autorelease];
    	    
    	   // WebPageController* controller = [[[WebPageController alloc] init:@""
    	   //                                                              Url:url Stack:stack] autorelease];
    	}
    }
    private void AttachEvents() { 

    	//复制到剪贴板按钮如何成为推广员
    	this.findViewById(R.id.copy_url_button).setOnClickListener(this);
    	
    	//分享赚红包按钮
    	this.findViewById(R.id.share_button).setOnClickListener(this);

    	this.findViewById(R.id.view_detail).setOnClickListener(this);
    }
    

	public void OnRequestComplete(int nRequestId, Requester req) {
	}

    @Override 
    protected void onDestroy() {
    	super.onDestroy();
    	TitleCtrl titleCtrl = (TitleCtrl)this.findViewById(R.id.title);
    	titleCtrl.SetEventLinstener(null);    	
    }
    
    private String m_strInviteUrl;
}
