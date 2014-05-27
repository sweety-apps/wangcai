package com.example.wangcai.activity;

import com.example.common.Util;
import com.example.request.ExchangeInfo;
import com.example.request.RequestManager;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.Requesters.Request_GetExchangeCode;
import com.example.request.Requesters.Request_GetExchangeList;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;
import com.example.wangcai.ctrls.ExchageGiftItem;
import com.example.wangcai.dialog.CommonDialog;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ExchageGiftActivity extends ManagedDialogActivity implements ExchageGiftItem.ExchageItemEvent, RequestManager.IRequestManagerCallback{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_exchage_gift);        

        InitView();
     }
    



    private void InitView() {
    	((Button)this.findViewById(R.id.task_detail)).setOnClickListener(new OnClickListener(){
    		public void onClick(View v) {
    			ActivityHelper.ShowDetailActivity(ExchageGiftActivity.this);
    		}
    	});
  
    	Request_GetExchangeList req = (Request_GetExchangeList)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_GetExchangeList);
    	RequestManager.GetInstance().SendRequest(req, false, this);

        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
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
					AddItem(parentView, item.m_strName, R.drawable.gift, item.m_strName, item.m_nPrice, item.m_nRemainCount);
				}
			} 
			else {
				Util.ShowRequestErrorMsg(this, req.GetMsg());
			}
		}
		else if (req instanceof Request_GetExchangeCode) {
			Request_GetExchangeCode detailReq = (Request_GetExchangeCode)req;
			if (nResult == 0) {
				//String strExchangeCode = detailReq.GetExchangeCode();
				//todo ExchangeCode
				
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
				//todo ²é¿´ÏêÇé
				ActivityHelper.ShowDetailActivity(this);
			}
		}
	}
	public void OnDoExchage(String strItemName) {
		int nBalance = WangcaiApp.GetInstance().GetUserInfo().GetBalance();
		
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
		
		Request_GetExchangeCode req = (Request_GetExchangeCode)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_GetExchangeCode);
    	req.SetExchangeType(m_selectedExchangeItem.m_nType);
    	
		RequestManager.GetInstance().SendRequest(req, false, this);
        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
	}
    private void AddItem(ViewGroup parentView, String strItemName, int nIconId, String strName, int nPrice, int nRemainCount) {
    	ExchageGiftItem item = new ExchageGiftItem(strItemName);
    	item.SetItemEventLinstener(this);
    	View view = item.Create(getApplicationContext(), nIconId, strName, nPrice, nRemainCount);
    	parentView.addView(view);
    }

    private ProgressDialog m_progressDialog = null;
    private ExchangeInfo m_exchangeInfo = null;
    private ExchangeInfo.ExchangeItem m_selectedExchangeItem = null;
    private CommonDialog m_hintExchangeSucceedDialog = null;
}




