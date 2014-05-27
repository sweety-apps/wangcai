package com.example.wangcai.activity;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.widget.ImageView;

import com.example.common.Util;
import com.example.request.ExtractInfo;
import com.example.request.RequestManager;
import com.example.request.Requester;
import com.example.request.RequesterFactory;
import com.example.request.UserInfo;
import com.example.request.Requesters.Request_ExtractAliPay;
import com.example.wangcai.R;
import com.example.wangcai.WangcaiApp;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.WangcaiActivity;
import com.example.wangcai.base.ManagedDialog;
import com.example.wangcai.base.ManagedDialogActivity;
import com.example.wangcai.ctrls.ExtractLineCtrl;
import com.example.wangcai.ctrls.ExtractPrieceCtrl;
import com.example.wangcai.dialog.CommonDialog;
import com.example.wangcai.dialog.HintBindPhoneDialog;
import com.example.wangcai.dialog.HintTaskLevelDialog;

public class ExtractAliPayActivity extends ManagedDialogActivity 
											implements ExtractPrieceCtrl.ExtractPrieceCtrlEvent, RequestManager.IRequestManagerCallback{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_extract_item);        

        InitView();
     }
    
    private void InitView() {
    	ImageView logo = (ImageView)findViewById(R.id.extract_logo);
    	logo.setBackgroundResource(R.drawable.extract_logo_alipay);
 
    	ExtractLineCtrl lineCtrl = (ExtractLineCtrl)findViewById(R.id.line1);
    	lineCtrl.SetText(getString(R.string.alipay_number_label), getString(R.string.alipay_number_hint));

    	lineCtrl = (ExtractLineCtrl)findViewById(R.id.line2);
    	lineCtrl.SetText(getString(R.string.input_agin_label), getString(R.string.input_agin_hint));

    	lineCtrl = (ExtractLineCtrl)findViewById(R.id.line3);
    	lineCtrl.SetText(getString(R.string.alipay_realname_label), getString(R.string.alipay_realname_hint));

    	ExtractInfo info = WangcaiApp.GetInstance().GetExtractInfo();
    	m_extractItem = info.GetExtractItem(ExtractInfo.ExtractType.ExtractType_AliPay);

    	int nIdList [] = {R.id.grid1, R.id.grid2, R.id.grid3};
    	int nItemCount = m_extractItem.m_subItems.size();
    	for (int i = 0; i < nItemCount && i < nIdList.length; ++i) {
    		ExtractInfo.ExtractSubItem subItem = m_extractItem.m_subItems.get(i);
    		ExtractPrieceCtrl ctrl = (ExtractPrieceCtrl)findViewById(nIdList[i]);
    		ctrl.SetPriece(subItem.m_nRealPrice);
    		ctrl.SetDiscountMoney(subItem.m_nAmount - subItem.m_nRealPrice);
    		ctrl.SetIsHot(subItem.m_bHot);
    		ctrl.SetEventListener(this);
    	}
    }
	public void OnDialogFinish(ManagedDialog dlg, int inClickedViewId) {
		int nDialogId = dlg.GetDialogId();
		if (m_bindPhoneDialog != null && nDialogId == m_bindPhoneDialog.GetDialogId()) {
			//绑定手机
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				ActivityHelper.ShowRegisterActivity(this);
			}
		}
		else if (m_hintExtractDialog != null && nDialogId == m_hintExtractDialog.GetDialogId()) {
			Request_ExtractAliPay request = (Request_ExtractAliPay)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_ExtractAliPay);
			request.SetAmount(m_selectedSubItem.m_nAmount);
			request.SetDiscount(m_selectedSubItem.m_nRealPrice);

			String strAliPayAccount = ((ExtractLineCtrl)findViewById(R.id.line1)).GetEditText();
			request.SetAliPayAccount(strAliPayAccount);
			RequestManager.GetInstance().SendRequest(request, false, this);
	        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
		}
	}

	public void OnPriceClick(ExtractPrieceCtrl ctrl) {
		UserInfo userInfo = WangcaiApp.GetInstance().GetUserInfo();
		if (!userInfo.HasBindPhone()) {
			if (m_bindPhoneDialog == null) {
				m_bindPhoneDialog = new HintBindPhoneDialog(this);
				RegisterDialog(m_bindPhoneDialog);
			}
			m_bindPhoneDialog.Show();
			return;
		}
		int nId = ctrl.getId();
		m_selectedSubItem = null;
		switch (nId) {
		case R.id.grid1:
			m_selectedSubItem = m_extractItem.m_subItems.get(0);
			break;
		case R.id.grid2:
			m_selectedSubItem = m_extractItem.m_subItems.get(1);
			break;
		case R.id.grid3:
			m_selectedSubItem = m_extractItem.m_subItems.get(2);
			break;
		}
		
		String strAliPayAccount1 = ((ExtractLineCtrl)findViewById(R.id.line1)).GetEditText();
		if (Util.IsEmptyString(strAliPayAccount1)) {
			ActivityHelper.ShowToast(this, R.string.hint_alipay_account_empty);
			return;			
		}
		String strAliPayAccount2 = ((ExtractLineCtrl)findViewById(R.id.line2)).GetEditText();
		if (!strAliPayAccount1.equals(strAliPayAccount2)) {
			ActivityHelper.ShowToast(this, R.string.hint_input_not_match);
			return;
		}
		
		String strRealName = ((ExtractLineCtrl)findViewById(R.id.line3)).GetEditText();
		if (Util.IsEmptyString(strRealName)) {
			ActivityHelper.ShowToast(this, R.string.hint_realname_empty);
			return;			
		}
		
		if (m_selectedSubItem.m_nRealPrice > WangcaiApp.GetInstance().GetUserInfo().GetBalance()){
			ActivityHelper.ShowToast(this, R.string.hint_no_enough_balance);
			return;
		}
		float fAmount = (float)m_selectedSubItem.m_nAmount / 100.0f;
		float fPrice = (float)m_selectedSubItem.m_nRealPrice / 100.0f;
		String strText = null;
		if (m_selectedSubItem.m_nAmount == m_selectedSubItem.m_nRealPrice) {
			strText = String.format("提现金额：%.0f元。", fAmount);
		}
		else {
			strText = String.format("提现金额：%.0f元，返现%.0f元。", fAmount, fAmount - fPrice);
		}
		strText += getString(R.string.hint_extract);

		if (m_hintExtractDialog == null) {
			m_hintExtractDialog = new CommonDialog(this);
			RegisterDialog(m_hintExtractDialog);
		}
		m_hintExtractDialog.SetInfo(null, strText, getString(R.string.confirm_extract), getString(R.string.cancel_text));
		m_hintExtractDialog.Show();

	}
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}
		
		if (req instanceof Request_ExtractAliPay){
			if (req.GetResult() == 0) {
				Request_ExtractAliPay extractReq = (Request_ExtractAliPay)req;
				String strOrderId = extractReq.GetOrderId();

				//请求完成, 更改余额
				WangcaiApp.GetInstance().ChangeBalance(-m_selectedSubItem.m_nRealPrice);
				
				//todo
			}
			else {
				Util.ShowRequestErrorMsg(this, req.GetMsg());
			}
		}
	}
	
	private ExtractInfo.ExtractItem m_extractItem = null;
    private HintBindPhoneDialog m_bindPhoneDialog = null;
    private CommonDialog m_hintExtractDialog = null;

    private ProgressDialog m_progressDialog = null;
    private ExtractInfo.ExtractSubItem m_selectedSubItem = null;
}


