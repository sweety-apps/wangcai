package com.coolstore.wangcai.activity;


import java.lang.ref.WeakReference;

import com.coolstore.common.Util;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.UserInfo;
import com.coolstore.request.Requesters.Request_BindPhone;
import com.coolstore.request.Requesters.Request_ResendCaptcha;
import com.coolstore.request.Requesters.Request_VerifyCaptcha;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.common.BuildSetting;
import com.coolstore.common.LogUtil;
import com.coolstore.common.TimerManager;
import com.coolstore.common.ViewHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.base.SmsReader;

import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;


public class RegisterActivity extends WangcaiActivity implements OnClickListener, 
														RequestManager.IRequestManagerCallback,
														TimerManager.TimerManagerCallback{

	
	private final static int sg_nTimerElapse = 1000;
	private final static int sg_nTotalCountDownSeconds = 60;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);        

        registerMessageReceiver();
        
        InitView();
    }
    
    
    private void InitView() {
    	//"获取验证码"
    	View viewGetCaptchaButton = findViewById(R.id.get_captcha_button);
    	ViewHelper.SetStateViewBkg(viewGetCaptchaButton, this, R.drawable.register_get_captcha, R.drawable.register_get_captcha_down, 0);
        viewGetCaptchaButton.setOnClickListener(this);
        
        //下一步按钮
        final View viewNextButton = findViewById(R.id.next_button);
        viewNextButton.setEnabled(false);
        
        ViewHelper.SetStateViewBkg(viewNextButton, this, R.drawable.register_next_button_normal, R.drawable.register_next_button_down, R.drawable.register_next_button_normal, R.drawable.register_next_button_disable);
        //m_viewerDrawer.AttachView(viewNextButton, R.drawable.register_next_button_normal, R.drawable.register_next_button_down, R.drawable.register_next_button_disable);
        viewNextButton.setOnClickListener(this);
        
        //"重新发送"
        findViewById(R.id.resend_text).setOnClickListener(this);
        
        //手机号编辑框
        final EditText editPhoneNumber = (EditText)this.findViewById(R.id.phone_number_edit);
        editPhoneNumber.setOnFocusChangeListener(new OnFocusChangeListener() {
			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				if (!hasFocus) {
					InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE); 
					imm.hideSoftInputFromWindow(editPhoneNumber.getWindowToken(),0);
				}
			}});
        
        //验证码编辑框
        final EditText editCaptcha = (EditText)this.findViewById(R.id.captcha_edit);
        editCaptcha.addTextChangedListener(new TextWatcher(){  
        	@Override  
        	public void afterTextChanged(Editable s) {  
        	}  
  
        	@Override  
        	public void beforeTextChanged(CharSequence s, int start, int count, int after) {                
        	}  
  
        	@Override  
        	public void onTextChanged(CharSequence s, int start, int before, int count) {
        		String strMsg = s.toString();
        		if (strMsg.length() == 5) {
        			viewNextButton.setEnabled(true);
        		}
        		else {
        			viewNextButton.setEnabled(false);
        		}
        	}          
        });
    }

	@Override
	public void onClick(View v) {
		int nId = v.getId();
		if (nId == R.id.get_captcha_button) {
			//获取验证码按钮
	        EditText editPhoneNumber = (EditText)this.findViewById(R.id.phone_number_edit);
	        m_strPhoneNumber = editPhoneNumber.getText().toString();
	        if (!CheckPhoneNumber(m_strPhoneNumber)) {
	        	ActivityHelper.ShowToast(this, R.string.hint_invlide_phoneNumber);
	        	return;
	        }

	        Request_BindPhone req = (Request_BindPhone)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_BindPhone);
	        req.SetPhoneNumber(m_strPhoneNumber);
	        
	        RequestManager.GetInstance().SendRequest(req, false, this);
	        
	        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
		}
		else if (nId == R.id.next_button) {
			//下一步按钮
	        EditText editCaptcha = (EditText)this.findViewById(R.id.captcha_edit);
	        String strCaptcha = editCaptcha.getText().toString();
	        if (strCaptcha.length() != 5) {
	        	ActivityHelper.ShowToast(this, R.string.hint_invite_captcha);
	        	return;	        	
	        }

	        Request_VerifyCaptcha req = (Request_VerifyCaptcha)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_VerifyCaptcha);
	        req.SetToken(m_strToken);
	        req.SetCaptcha(strCaptcha);
	        RequestManager.GetInstance().SendRequest(req, false, this);
	        
	        m_progressDialog = ActivityHelper.ShowLoadingDialog(this, getString(R.string.hint_verifying_captcha));
		}
		else if (nId == R.id.resend_text) {
			//重新发送
	        Request_ResendCaptcha req = (Request_ResendCaptcha)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_ResendCaptcha);
	        req.SetOldToken(m_strToken);
	        RequestManager.GetInstance().SendRequest(req, false, this);	

	        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
		}
	}

	private void OnRequestCaptcha() {
		TextView view = (TextView)findViewById(R.id.count_down_text);
		view.setText(String.format(getString(R.string.bind_phone_count_down), m_nRemainSeconds));
		view.setVisibility(View.VISIBLE);

		findViewById(R.id.resend_text).setVisibility(View.GONE);
		findViewById(R.id.get_captcha_button).setVisibility(View.GONE);
		EditText edit = (EditText)findViewById(R.id.captcha_edit);
		edit.setVisibility(View.VISIBLE);
		edit.requestFocus();
		StartTimer();		
	}
	private void OnRequestCaptchaComplete(int nResult, String strMsg, String strToken) {
		if (nResult == 0) {
			m_strToken = strToken;
			OnRequestCaptcha();
		}
		else {
			if (Util.IsEmptyString(strMsg)) {
				ActivityHelper.ShowToast(this, R.string.hint_send_sms_fail);
			}
			else {
				ActivityHelper.ShowToast(this, strMsg);
			}
		}		
	}
	
	@Override
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}
		if (req instanceof Request_BindPhone) {
			//请求验证码
			Request_BindPhone bindReq = (Request_BindPhone)req;
			OnRequestCaptchaComplete(req.GetResult(), req.GetMsg(), bindReq.GetToken());
		}
		else if (req instanceof Request_ResendCaptcha){
			//重发验证码
			Request_ResendCaptcha resendReq = (Request_ResendCaptcha)req;
			OnRequestCaptchaComplete(req.GetResult(), req.GetMsg(), resendReq.GetNewToken());			
		}
		else if (req instanceof Request_VerifyCaptcha){
			//检查验证码
			Request_VerifyCaptcha verifyReq = (Request_VerifyCaptcha)req;
			int nResult = verifyReq.GetResult();
			if (nResult == 0) {
				UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();
				userInfo.SetUserId(verifyReq.GetUserId());
				userInfo.SetInviteCode(verifyReq.GetInviteCode());
				userInfo.SetInviter(verifyReq.GetInviter());
				userInfo.SetBalance(verifyReq.GetBalance());
				userInfo.SetTotalIncome(verifyReq.GetIncome());
				userInfo.SetTotalOutgo(verifyReq.GetOutgo());
				userInfo.SetShareIncome(verifyReq.GetShareIncome());
				userInfo.SetPhoneNumber(m_strPhoneNumber);
				//更新UserInfo以刷新界面
				WangcaiApp.GetInstance().UpdateUserInfo(userInfo);
				
				int nBindDeviceCount = verifyReq.GetBindDeviceCount();
				ActivityHelper.ShowRegisterSucceedActivity(this, nBindDeviceCount);
			}
			else {
				String strMsg = verifyReq.GetMsg();
				if (Util.IsEmptyString(strMsg)) {
					ActivityHelper.ShowToast(this, R.string.hint_verify_captcha_fail);
				}
				else {
					ActivityHelper.ShowToast(this, strMsg);
				}
			}			
		}
	}

    
	private boolean CheckPhoneNumber(String strPhoneNumber) {
        if (strPhoneNumber.length() != 11) {
        	return false;
        }
        if (!isNumeric(strPhoneNumber)) {
        	return false;
        }
		return true;
	}
	private boolean isNumeric(String str){  
		for (int i = str.length() - 1; i>=0; i--){    
			if (!Character.isDigit(str.charAt(i))){  
				return false;  
			}  
		}  
		return true;  
	} 
	

    @Override 
    protected void onDestroy() {
    	StopTimer();
    	//m_viewerDrawer.DetachAll();

		unregisterReceiver(m_messageReceiver);
    	super.onDestroy();
    }


    private void StartTimer() {
    	m_nRemainSeconds = sg_nTotalCountDownSeconds;

    	m_nCountDownTimerId = TimerManager.GetInstance().StartTimer(sg_nTimerElapse, this);
    }
    private void StopTimer() {
    	if (m_nCountDownTimerId > 0) {
    		TimerManager.GetInstance().StopTimer(m_nCountDownTimerId);
    		m_nCountDownTimerId = 0;
    	}
	}

	@Override
	public void OnTimer(int nId, int nHitTimes) {
		// TODO Auto-generated method stub
		m_nRemainSeconds--;
		if (m_nRemainSeconds < 0) {
			StopTimer();
			findViewById(R.id.resend_text).setVisibility(View.VISIBLE);
			findViewById(R.id.count_down_text).setVisibility(View.GONE);
			return;
		}
		String strText = String.format(getString(R.string.bind_phone_count_down), m_nRemainSeconds);
    	TextView countDownText = (TextView)findViewById(R.id.count_down_text);
		countDownText.setText(strText);
	}
    
    private static class MsgHandler extends Handler {
    	public MsgHandler(RegisterActivity owner) {
    		m_owner = new WeakReference<RegisterActivity>(owner);
    	}
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == sg_nNewSms) {
                Bundle b = msg.getData();
                String strCode = b.getString("Code");

                RegisterActivity owner = m_owner.get();
                if (owner != null) {
	                EditText editCaptcha = (EditText)owner.findViewById(R.id.captcha_edit);
	                editCaptcha.setText(strCode);
                }
            }
            super.handleMessage(msg);
        }
		private WeakReference<RegisterActivity> m_owner;
    }
    
    private Handler m_msgHandler = new MsgHandler(this);
    
    private final static int sg_nNewSms = 1212;


	public class MessageReceiver extends BroadcastReceiver {
		@Override
		public void onReceive(Context context, Intent intent) {
			String strAction = intent.getAction();
			if (strAction.equals("android.provider.Telephony.SMS_RECEIVED")) {
				
			}
			else if (strAction.equals(SmsReader.SmsMessageReceiveAction)) {
	            LogUtil.LogPush("MainActivity  receive broadcast(%s)", intent.getAction());
				if (SmsReader.SmsMessageReceiveAction.equals(intent.getAction())) {
	              String strSmsContent = intent.getStringExtra(SmsReader.sg_strSmsContent);
	              LogUtil.LogPush("RegisterActivity  receive sms  broadcast(%s)", strSmsContent);
	              OnNewSms(strSmsContent);
				}
			}
		}
	}	

	public void registerMessageReceiver() {
		m_messageReceiver = new MessageReceiver();
		IntentFilter filter = new IntentFilter();
		filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
		filter.addAction(SmsReader.SmsMessageReceiveAction);
		registerReceiver(m_messageReceiver, filter);
		
		//IntentFilter filter = new IntentFilter("android.provider.Telephony.SMS_RECEIVED");  
		//filter.setPriority(IntentFilter.SYSTEM_HIGH_PRIORITY);
		//filter.addAction("android.provider.Telephony.SMS_RECEIVED");
		//registerReceiver(m_messageReceiver, filter);
	}
	
	
    
    //您的验证码是：【22425】。请不要把验证码泄露给其他人。如非本人操作，可不用理会！【旺财】
  	public void OnNewSms(String strMsg){
  		//收到短信
   	   if (BuildSetting.sg_bIsDebug) {
  		   strMsg = "您的验证码是：【22425】。请不要把验证码泄露给其他人。如非本人操作，可不用理会！【旺财】";
  	   }
  	   if (!strMsg.contains("【旺财】")) {
  		   return;
  	   }

  	   int nIndex = strMsg.indexOf("验证码");
  	   if (nIndex < 0){
  		   return;
  	   }
  	   
  	   int nBeginIndex = strMsg.indexOf("【", nIndex);
  	   int nEndIndex = strMsg.indexOf("】", nBeginIndex);
  	   String strCode = strMsg.substring(nBeginIndex + 1, nEndIndex);
  	   

		Message msg = new Message();
		msg.what = sg_nNewSms;
		Bundle b = new Bundle();
		b.putString("Code",  strCode);
		msg.setData(b);
		m_msgHandler.sendMessage(msg);

  	}
  	
  
    //data member
	private MessageReceiver m_messageReceiver = null;
    private int m_nRemainSeconds = sg_nTotalCountDownSeconds;
    private String m_strPhoneNumber;
    private ProgressDialog m_progressDialog;
	//private ViewDrawer m_viewerDrawer = new ViewDrawer();
	private String m_strToken;
	private int m_nCountDownTimerId = 0;

}
