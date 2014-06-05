package com.coolstore.wangcai.activity;

import com.coolstore.common.BuildSetting;
import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.request.ExchangeInfo;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.UserInfo;
import com.coolstore.request.Requesters.Request_GetExchangeCode;
import com.coolstore.request.Requesters.Request_GetExchangeList;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;
import com.coolstore.wangcai.ctrls.ExchageGiftItem;
import com.coolstore.wangcai.dialog.CommonDialog;
import com.coolstore.wangcai.dialog.HintBindPhoneDialog;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStub;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class ExchageGiftActivity extends ManagedDialogActivity implements ExchageGiftItem.ExchageItemEvent, RequestManager.IRequestManagerCallback{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_exchage_gift);        

        InitView();
     }
    




    private void InitView() {
    	this.findViewById(R.id.task_detail).setOnClickListener(new OnClickListener(){
    		public void onClick(View v) {
    			ActivityHelper.ShowDetailActivity(ExchageGiftActivity.this);
    		}
    	});
  
    	TextView text = (TextView)findViewById(R.id.usable_balance);
    	text.setText(String.format(getString(R.string.usable_balance), (float)WangcaiApp.GetInstance().GetUserInfo().GetBalance() / 100.0f));
   
    	ViewHelper.SetStateViewBkg(findViewById(R.id.task_detail), this, R.drawable.jiaoyi, R.drawable.jiaoyi_sel);
    	
    	Request_GetExchangeList req = (Request_GetExchangeList)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_GetExchangeList);
    	req.SetAppName(BuildSetting.sg_strAppName);
    	req.SetVersion(BuildSetting.sg_strVersion);
    	req.SetTimeStamp(String.valueOf(System.currentTimeMillis()));
    	RequestManager.GetInstance().SendRequest(req, false, this);

        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
        
      	
    	if (!WangcaiApp.GetInstance().GetUserInfo().HasBindPhone()) {
    		ViewStub stub = (ViewStub) findViewById(R.id.bind_phone_tip);  
    		stub.inflate(); 

    		View bindButton = findViewById(R.id.bind_phone_button);
        	ViewHelper.SetStateViewBkg(bindButton, this, R.drawable.mywangcai_bingdphone_btn, R.drawable.mywangcai_bingdphone_btn_pressed);
        	bindButton.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					ActivityHelper.ShowRegisterActivity(ExchageGiftActivity.this);
				}    		
    		});
    	}
    }

	public void OnRequestComplete(int nRequestId, Requester req) {
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}

		int nResult = req.GetResult();
		if (req instanceof Request_GetExchangeList) {
			if (nResult == 0) {
		    	ViewGroup parentView = (ViewGroup)this.findViewById(R.id.item_list);

		    	Request_GetExchangeList detailReq = (Request_GetExchangeList)req;
		    	m_exchangeInfo = detailReq.GetExchangeInfo();
				int nCount = m_exchangeInfo.GetExchangeItemCount();
				for (int i = 0; i < nCount; i++) {
					ExchangeInfo.ExchangeItem item = m_exchangeInfo.GetExchangeItem(i);
					AddItem(parentView, item.m_strName, item.m_strIconUrl, item.m_strName, item.m_nPrice, item.m_nRemainCount);
				}
			} 
			else {
				Util.ShowRequestErrorMsg(this, req.GetMsg());
			}
		}
		else if (req instanceof Request_GetExchangeCode) {
			Request_GetExchangeCode detailReq = (Request_GetExchangeCode)req;
			if (nResult == 0) {				
				//减余额
				WangcaiApp.GetInstance().ChangeBalance(-m_selectedExchangeItem.m_nPrice);
				
				ActivityHelper.ShowToast(this, R.string.hint_exchange_succeed);
				
				if (m_hintExchangeSucceedDialog == null) {
					m_hintExchangeSucceedDialog = new CommonDialog(this);
					RegisterDialog(m_hintExchangeSucceedDialog);
				}
				m_hintExchangeSucceedDialog.SetInfo(getString(R.string.exchange_complete), 
						getString(R.string.hint_exchange_succeed), getString(R.string.ok_text), getString(R.string.view_detail));
				m_hintExchangeSucceedDialog.Show();				
			}
			else {
				Util.ShowRequestErrorMsg(this, req.GetMsg());
			}
		}
	}
	public void OnDialogFinish(ManagedDialog dlg, int inClickedViewId) {
		int nDialogId = dlg.GetDialogId();
		if (m_hintExchangeSucceedDialog != null && nDialogId == m_hintExchangeSucceedDialog.GetDialogId()) {
			if (inClickedViewId == DialogInterface.BUTTON_NEGATIVE) {
				//todo 查看详情
				ActivityHelper.ShowDetailActivity(this);
			}
		}
		else if (m_hintBindPhoneDialog != null && nDialogId == m_hintBindPhoneDialog.GetDialogId()) {
			//绑定手机
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				ActivityHelper.ShowRegisterActivity(this);
			}
		}
	}
	public void OnDoExchage(String strItemName) {
		WangcaiApp app = WangcaiApp.GetInstance();
		UserInfo userInfo = app.GetUserInfo();
		if (!userInfo.HasBindPhone()) {
			if (m_hintBindPhoneDialog == null) {
				m_hintBindPhoneDialog = new HintBindPhoneDialog(this);
				RegisterDialog(m_hintBindPhoneDialog);
			}
			m_hintBindPhoneDialog.Show();
			return;
		}
//		int nBalance = userInfo.GetBalance();
		
		m_selectedExchangeItem= null;
		int nCount = m_exchangeInfo.GetExchangeItemCount();
		for (int i = 0; i < nCount; i++) {
			ExchangeInfo.ExchangeItem item = m_exchangeInfo.GetExchangeItem(i);
			if (item.m_strName.equals(strItemName)) {
				m_selectedExchangeItem = item;
				break;
			}
		}
		if (m_selectedExchangeItem == null) {
			return ;
		}

		//余额不足
		if (m_selectedExchangeItem.m_nPrice > WangcaiApp.GetInstance().GetUserInfo().GetBalance()){
			ActivityHelper.ShowToast(this, R.string.hint_no_enough_balance);
			return;
		}
		
		
		Request_GetExchangeCode req = (Request_GetExchangeCode)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_GetExchangeCode);
    	req.SetExchangeType(m_selectedExchangeItem.m_nType);
    	
		RequestManager.GetInstance().SendRequest(req, false, this);
        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
	}
    private void AddItem(ViewGroup parentView, String strItemName, String strIconUrl, String strName, int nPrice, int nRemainCount) {
    	ExchageGiftItem item = new ExchageGiftItem(strItemName);
    	item.SetItemEventLinstener(this);
    	View view = item.Create(getApplicationContext(), strIconUrl, strName, nPrice, nRemainCount);
    	parentView.addView(view);
    }

    private ProgressDialog m_progressDialog = null;
    private ExchangeInfo m_exchangeInfo = null;
    private ExchangeInfo.ExchangeItem m_selectedExchangeItem = null;
    private CommonDialog m_hintExchangeSucceedDialog = null;
    private HintBindPhoneDialog m_hintBindPhoneDialog = null;
}




