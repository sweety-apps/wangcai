package com.example.wangcai;

import com.example.request.Request_VerifyCaptcha;
import com.example.request.RequestManager;
import com.example.request.Request_BindPhone;
import com.example.request.Request_ResendCaptcha;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.UserInfo;
import com.example.request.Util;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

public class RegisterActivity extends ManagedActivity implements OnClickListener, RequestManager.IRequestManagerCallback {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);        

        InitView();
    }
    
    private void InitView() {
    	View viewGetCaptchaButton = findViewById(R.id.get_captcha_button);
        m_viewerDrawer.AttachView(viewGetCaptchaButton, R.drawable.register_get_captcha, R.drawable.register_get_captcha_down, 0);
        viewGetCaptchaButton.setOnClickListener(this);
        
    	View viewNextButton = findViewById(R.id.next_button);
        m_viewerDrawer.AttachView(viewNextButton, R.drawable.register_next_button_normal, R.drawable.register_next_button_down, R.drawable.register_next_button_disable);
        viewNextButton.setOnClickListener(this);
        
        final EditText editPhoneNumber = (EditText)this.findViewById(R.id.phone_number_edit);
        editPhoneNumber.setOnFocusChangeListener(new OnFocusChangeListener() {
			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				if (!hasFocus) {
					InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE); 
					imm.hideSoftInputFromWindow(editPhoneNumber.getWindowToken(),0);
				}
			}});
    }

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		int nId = v.getId();
		if (nId == R.id.get_captcha_button) {
	        EditText editPhoneNumber = (EditText)this.findViewById(R.id.phone_number_edit);
	        String strPhoneNumber = editPhoneNumber.getText().toString();
	        if (!CheckPhoneNumber(strPhoneNumber)) {
	        	ActivityHelper.ShowToast(this, R.string.input_phone_number_hint);
	        	return;
	        }

	        Request_BindPhone req = (Request_BindPhone)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_BindPhone);
	        req.SetPhoneNumber(strPhoneNumber);
	        
	        RequestManager.GetInstance().SendRequest(req, false, this);
		}
		else if (nId == R.id.next_button) {
	        EditText editCaptcha = (EditText)this.findViewById(R.id.captcha_edit);
	        String strCaptcha = editCaptcha.getText().toString();

	        Request_VerifyCaptcha req = (Request_VerifyCaptcha)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_VerifyCaptcha);
	        req.SetToken(m_strToken);
	        req.SetCaptcha(strCaptcha);
	        RequestManager.GetInstance().SendRequest(req, false, this);
		}
	}

	@Override
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (req instanceof Request_BindPhone) {
			//绑定手机
			Request_BindPhone bindReq = (Request_BindPhone)req;
			int nResult = bindReq.GetResult();
			if (nResult == 0) {
				m_strToken = bindReq.GetToken();
			}
			else {
				String strMsg = bindReq.GetMsg();
				if (Util.IsEmptyString(strMsg)) {
					ActivityHelper.ShowToast(this, R.string.hint_send_sms_fail);
				}
				else {
					ActivityHelper.ShowToast(this, strMsg);
				}
			}
		}
		else if (req instanceof Request_ResendCaptcha){
			//重发验证码
			Request_ResendCaptcha resendReq = (Request_ResendCaptcha)req;
			int nResult = resendReq.GetResult();
			if (nResult == 0) {
				m_strToken = resendReq.GetNewToken();
			}
			else {
			}
			
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
				//更新UserInfo以刷新界面
				WangcaiApp.GetInstance().UpdateUserInfo(userInfo);
				
				int nBindDeviceCount = verifyReq.GetBindDeviceCount();
				ActivityHelper.ShowRegisterSucceedActivity(this, nBindDeviceCount);
			}
			else {
				String strMsg = verifyReq.GetMsg();
				if (Util.IsEmptyString(strMsg)) {
					ActivityHelper.ShowToast(this, R.string.hint_send_sms_fail);
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
		for (int i = str.length();--i>=0;){    
			if (!Character.isDigit(str.charAt(i))){  
				return false;  
			}  
		}  
		return true;  
	} 


    ViewDrawer m_viewerDrawer = new ViewDrawer();
    String m_strToken;
}
