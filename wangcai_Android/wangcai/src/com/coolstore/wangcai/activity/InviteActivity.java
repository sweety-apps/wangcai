package com.coolstore.wangcai.activity;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.onekeyshare.ShareContentCustomizeCallback;

import com.coolstore.common.Config;
import com.coolstore.common.Util;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.UserInfo;
import com.coolstore.wangcai.ConfigCenter;
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
import android.util.Log;
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
    	//��ά��
    	
    	WangcaiApp app = WangcaiApp.GetInstance();
    	UserInfo userInfo = app.GetUserInfo();
    	
    	//������
    	String strInvideCode = userInfo.GetInviteCode();
    	if (!Util.IsEmptyString(strInvideCode)) {
        	TextView inviteCodeView = (TextView)this.findViewById(R.id.invite_code);    		
    		inviteCodeView.setText(strInvideCode);

        	ImageView qrcodeView = (ImageView)this.findViewById(R.id.qrcode);
            
        	String strInviteUrl = String.format(Config.GetInviteUrl(), strInvideCode);
        	qrcodeView.setImageBitmap(Util.CreateQRCodeBitmap(strInviteUrl, getResources().getDimensionPixelSize(R.dimen.qrcode_size)));
    	}

    	//��������
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
    		/*
    	    id<ISSContent> publishContent = [ShareSDK content: [NSString stringWithFormat:
    	    	@"������Ҳ���õ����ҵĻ����ˣ��������ص�ַ:%@", url]  
    	    defaultContent:[NSString stringWithFormat:@"������Ҳ���õ����ҵĻ����ˡ�"] 
    	    		image:[ShareSDK imageWithPath:imagePath] 
    	    	title: @"��Ӧ������" 
    	    	url:url description: @"���Ʒ���" 
    	    	mediaType: SSPublishContentMediaTypeNews];
    	  
    	    [publishContent addQQUnitWithType: [NSNumber numberWithInt:SSPublishContentMediaTypeNews]
    	            content:@"������Ҳ���õ����ҵĻ����ˡ�"
    	            title:@"��Ӧ������"
    	            url:url
    	            image:[ShareSDK imageWithPath:imagePath]];
    	    
    	    */
    		UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();
			//String strInviteCode = userInfo.GetInviteCode();
			String strInviteUrl = userInfo.GetInviteTaskUrl();
    
			OnekeyShare oks = new OnekeyShare();
			oks.setNotification(R.drawable.ic_launcher, getString(R.string.app_description));
			oks.setTitle(getString(R.string.share_title));
			oks.setUrl(strInviteUrl);
			oks.setSite(getString(R.string.app_name));
			oks.setSiteUrl(strInviteUrl);
			oks.setTitleUrl(strInviteUrl);
			String strImagePath = Util.GetMainLogoPath(this);
			if (!Util.IsEmptyString(strImagePath)) {
				oks.setImagePath(strImagePath);
				oks.setFilePath(strImagePath);
			}
			String strMsg = String.format(getString(R.string.invite_share_content), strInviteUrl);
			oks.setText(strMsg);
			oks.setShareContentCustomizeCallback(new ShareContentCustomizeCallback() {
				public void onShare(Platform platform, ShareParams paramsToShare) {
					if ("QZone".equals(platform.getName())) {
						//String text = platform.getContext().getString(R.string.share_content_short);
						String strQZoneNewText = platform.getContext().getString(R.string.qzone_invite_share_content);
						paramsToShare.setText(strQZoneNewText);
					}
				}
			});
			oks.setCallback(new PlatformActionListener(){
				@Override
				public void onComplete(Platform palt, int nAction, HashMap<String, Object> res) {
					Log.d(getClass().getSimpleName(), res.toString());		
				}			
				@Override
				public void onError(Platform plat, int action, Throwable t) {
					t.printStackTrace();
				}			
				@Override
				public void onCancel(Platform plat, int action) {
				}
			});
			oks.show(this.getApplicationContext());
    	}
    	else if (nId == R.id.view_detail) {
    		ActivityHelper.ShowWebViewActivity(this, getString(R.string.invite_rull_detail_title), Config.GetInviteRuleUrl());
    	}
    } 
    private void AttachEvents() { 
    	//���Ƶ������尴ť
    	this.findViewById(R.id.copy_url_button).setOnClickListener(this);
    	
    	//����׬�����ť
    	this.findViewById(R.id.share_button).setOnClickListener(this);

    	//��γ�Ϊ�ƹ�Ա
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
