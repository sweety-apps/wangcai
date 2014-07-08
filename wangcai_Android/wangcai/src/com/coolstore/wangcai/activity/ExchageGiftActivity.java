package com.coolstore.wangcai.activity;

import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.request.ExchangeListInfo;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.UserInfo;
import com.coolstore.request.Requesters.Request_GetExchangeCode;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;
import com.coolstore.wangcai.ctrls.ExchageGiftItem;
import com.coolstore.wangcai.dialog.CommonDialog;
import com.coolstore.wangcai.dialog.ExtractHintDialog;
import com.coolstore.wangcai.dialog.HintBindPhoneDialog;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStub;
import android.view.View.OnClickListener;
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
    	

    	WangcaiApp app = WangcaiApp.GetInstance();
    	m_exchangeListInfo = app.GetExchangeListInfo();
    	if (m_exchangeListInfo == null) {
    		app.RequestExchangeListInfo();
    		m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
    	}
    	else {
    		UpdateItemList();
    	}
      	
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

    private void UpdateItemList() {
    	ViewGroup parentView = (ViewGroup)this.findViewById(R.id.item_list);
    	parentView.removeAllViews();

		int nCount = m_exchangeListInfo.GetExchangeItemCount();
		for (int i = 0; i < nCount; i++) {
			ExchangeListInfo.ExchangeItem item = m_exchangeListInfo.GetExchangeItem(i);
			AddItem(parentView, item.m_strName, item.m_strIconUrl, item.m_strName, item.m_nPrice, item.m_nRemainCount);
		}    	
    }

	@Override
	public void OnExchangeListRequestComplete(int nVersion, int nResult, String strMsg){	
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}
		if (nResult == 0) {
	    	WangcaiApp app = WangcaiApp.GetInstance();
	    	m_exchangeListInfo = app.GetExchangeListInfo();
    		UpdateItemList();
		} 
		else {
			Util.ShowRequestErrorMsg(this, strMsg);
		}
	}
	
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}

		int nResult = req.GetResult();
		if (req instanceof Request_GetExchangeCode) {
			//Request_GetExchangeCode detailReq = (Request_GetExchangeCode)req;
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
		else if (m_hintExtractDialog != null && nDialogId == m_hintExtractDialog.GetDialogId()) {
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				Request_GetExchangeCode req = (Request_GetExchangeCode)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_GetExchangeCode);
		    	req.SetExchangeType(m_selectedExchangeItem.m_nType);
		    	
				RequestManager.GetInstance().SendRequest(req, false, this);
		        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
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
		int nCount = m_exchangeListInfo.GetExchangeItemCount();
		for (int i = 0; i < nCount; i++) {
			ExchangeListInfo.ExchangeItem item = m_exchangeListInfo.GetExchangeItem(i);
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

		String strAccount = String.format(getString(R.string.echange_dialog_name), m_selectedExchangeItem.m_strName);
		String strMoney = String.format(getString(R.string.echange_dialog_price), Util.FormatMoney(m_selectedExchangeItem.m_nPrice));

		m_hintExtractDialog = new ExtractHintDialog(this);
		RegisterDialog(m_hintExtractDialog);

		m_hintExtractDialog.SetInfo(strAccount, strMoney);
		m_hintExtractDialog.SetHintText(getString(R.string.exchagne_hint_text));
		m_hintExtractDialog.SetButtonText(getString(R.string.confirm_exchange_text), null);
		m_hintExtractDialog.Show();
	}
	
    private void AddItem(ViewGroup parentView, String strItemName, String strIconUrl, String strName, int nPrice, int nRemainCount) {
    	ExchageGiftItem item = new ExchageGiftItem(strItemName);
    	item.SetItemEventLinstener(this);
    	View view = item.Create(getApplicationContext(), strIconUrl, strName, nPrice, nRemainCount);
    	parentView.addView(view);
    }

    private ProgressDialog m_progressDialog = null;
    private ExchangeListInfo m_exchangeListInfo = null;
    private ExchangeListInfo.ExchangeItem m_selectedExchangeItem = null;
    private CommonDialog m_hintExchangeSucceedDialog = null;
    private HintBindPhoneDialog m_hintBindPhoneDialog = null;
    private ExtractHintDialog m_hintExtractDialog = null;
}




