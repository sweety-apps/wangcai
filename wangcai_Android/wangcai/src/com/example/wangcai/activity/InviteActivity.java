package com.example.wangcai.activity;

import com.example.common.Util;
import com.example.request.Config;
import com.example.request.RequestManager;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.UserInfo;
import com.example.request.Requesters.Request_UpdateInviter;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.WangcaiActivity;
import com.example.wangcai.ctrls.TitleCtrl;

import android.annotation.SuppressLint;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
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
    	//��ά��
    	
    	WangcaiApp app = WangcaiApp.GetInstance();
    	UserInfo userInfo = app.GetUserInfo();
    	
    	//������
    	String strInvideCode = userInfo.GetInviteCode();
    	if (!Util.IsEmptyString(strInvideCode)) {
        	TextView inviteCodeView = (TextView)this.findViewById(R.id.invite_code);    		
    		inviteCodeView.setText(strInvideCode);

        	ImageView qrcodeView = (ImageView)this.findViewById(R.id.qrcode);
            
        	qrcodeView.setImageBitmap(Util.CreateQRCodeBitmap(strInvideCode, getResources().getDimensionPixelSize(R.dimen.qrcode_size)));
    	}

    	//��������
    	View view = this.findViewById(R.id.invite_url_text);;
    	TextView invateUrlView = (TextView)view;
    	m_strInviteUrl = userInfo.GetInviteUrl();
    	if (!Util.IsEmptyString(m_strInviteUrl)) {
    		invateUrlView.setText(m_strInviteUrl);
    	}
    	
    	TextView awardText = ((TextView)findViewById(R.id.friend_award));
    	String strText = String.format(getString(R.string.invite_friend_award), (float)userInfo.GetShareIncome() / 100.0f);
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
    		ActivityHelper.ShowWebViewActivity(this, getString(R.string.invite_rull_detail_title), Config.GetWebServiceUrl() + "123");
    	    //NSString* url = [[[NSString alloc] initWithFormat:@"%@123", WEB_SERVICE_VIEW] autorelease];
    	    
    	   // WebPageController* controller = [[[WebPageController alloc] init:@""
    	   //                                                              Url:url Stack:stack] autorelease];
    	}
    }
    private void AttachEvents() { 

    	//���Ƶ������尴ť��γ�Ϊ�ƹ�Ա
    	this.findViewById(R.id.copy_url_button).setOnClickListener(this);
    	
    	//����׬�����ť
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
