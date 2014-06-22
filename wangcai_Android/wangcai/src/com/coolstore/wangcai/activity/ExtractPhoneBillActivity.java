package com.coolstore.wangcai.activity;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.text.InputType;
import android.view.View;
import android.widget.ImageView;

import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.request.ExtractInfo;
import com.coolstore.request.RequestManager;
import com.coolstore.request.Requester;
import com.coolstore.request.RequesterFactory;
import com.coolstore.request.UserInfo;
import com.coolstore.request.Requesters.Request_ExtractPhoneBill;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.ManagedDialog;
import com.coolstore.wangcai.base.ManagedDialogActivity;
import com.coolstore.wangcai.ctrls.ExtractLineCtrl;
import com.coolstore.wangcai.ctrls.ExtractPrieceCtrl;
import com.coolstore.wangcai.ctrls.TitleCtrl;
import com.coolstore.wangcai.dialog.ExtractHintDialog;
import com.coolstore.wangcai.dialog.HintBindPhoneDialog;

public class ExtractPhoneBillActivity extends ManagedDialogActivity 
												implements ExtractPrieceCtrl.ExtractPrieceCtrlEvent, RequestManager.IRequestManagerCallback{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_extract_item);        

        InitView();
     }
    
    private void InitView() {
    	TitleCtrl title = (TitleCtrl)findViewById(R.id.title);
    	title.SetTitle(getString(R.string.extract_phonebill));
    	
    	ViewHelper.SetTextStr(this, R.id.extract_item_text, getString(R.string.extract_phone_bill_lebal));
    	ViewHelper.SetTextStr(this, R.id.extract_item_sub_text, getString(R.string.extract_phone_bill_sub_text));
    	findViewById(R.id.extract_item_sub_text).setVisibility(View.VISIBLE);
   
    	ImageView logo = (ImageView)findViewById(R.id.extract_logo);
    	logo.setBackgroundResource(R.drawable.register_phone_logo);
 
    	ExtractLineCtrl lineCtrl = (ExtractLineCtrl)findViewById(R.id.line1);
    	lineCtrl.SetText(getString(R.string.phone_number_label), getString(R.string.phone_number_hint));
    	lineCtrl.GetEditCtrl().setInputType(InputType.TYPE_CLASS_PHONE);

    	lineCtrl = (ExtractLineCtrl)findViewById(R.id.line2);
    	lineCtrl.SetText(getString(R.string.input_agin_label), getString(R.string.input_agin_hint));
    	lineCtrl.GetEditCtrl().setInputType(InputType.TYPE_CLASS_PHONE);

    	lineCtrl = (ExtractLineCtrl)findViewById(R.id.line3);
    	lineCtrl.setVisibility(View.GONE);

    	ExtractInfo info = WangcaiApp.GetInstance().GetExtractInfo();
    	m_extractItem = info.GetExtractItem(ExtractInfo.ExtractType.ExtractType_Phone);

    	int nIdList [] = {R.id.grid1, R.id.grid2, R.id.grid3};
    	int nItemCount = m_extractItem.m_subItems.size();
    	for (int i = 0; i < nItemCount && i < nIdList.length; ++i) {
    		ExtractInfo.ExtractSubItem subItem = m_extractItem.m_subItems.get(i);
    		ExtractPrieceCtrl ctrl = (ExtractPrieceCtrl)findViewById(nIdList[i]);
    		ctrl.SetPriece(subItem.m_nAmount);
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
			if (inClickedViewId == DialogInterface.BUTTON_POSITIVE) {
				Request_ExtractPhoneBill request = (Request_ExtractPhoneBill)RequesterFactory.NewRequest(RequesterFactory.RequestType.RequestType_ExtractPhoneBill);
				request.SetAmount(m_selectedSubItem.m_nAmount);
				request.SetDiscount(m_selectedSubItem.m_nRealPrice);
	
				String strPhoneNumber = ((ExtractLineCtrl)findViewById(R.id.line1)).GetEditText();
				request.SetPhoneNumber(strPhoneNumber);
				RequestManager.GetInstance().SendRequest(request, false, this);
		        m_progressDialog = ActivityHelper.ShowLoadingDialog(this);
			}
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
		
		String strPhoneNumber1 = ((ExtractLineCtrl)findViewById(R.id.line1)).GetEditText();
		if (Util.IsEmptyString(strPhoneNumber1)) {
			ActivityHelper.ShowToast(this, R.string.hint_phone_number_empty);
			return;			
		}
		String strPhoneNumber2 = ((ExtractLineCtrl)findViewById(R.id.line2)).GetEditText();
		if (!strPhoneNumber1.equals(strPhoneNumber2)) {
			ActivityHelper.ShowToast(this, R.string.hint_input_not_match);
			return;
		}
		
		if (m_selectedSubItem.m_nRealPrice > WangcaiApp.GetInstance().GetUserInfo().GetBalance()){
			ActivityHelper.ShowToast(this, R.string.hint_no_enough_balance);
			return;
		}
		
		String strAccount = String.format(getString(R.string.extract_dialog_phone_account), strPhoneNumber1);
		
		String strMoney = null;
		if (m_selectedSubItem.m_nAmount == m_selectedSubItem.m_nRealPrice) {
			strMoney = String.format(getString(R.string.extract_dialog_phone_money), Util.FormatMoney(m_selectedSubItem.m_nRealPrice));
		}
		else {
			String strAmout = Util.FormatMoney(m_selectedSubItem.m_nAmount);
			String strDiscount = Util.FormatMoney(m_selectedSubItem.m_nAmount - m_selectedSubItem.m_nRealPrice);
			strMoney = String.format(getString(R.string.extract_dialog_phone_money_with_discount), strAmout, strDiscount);
		}


		m_hintExtractDialog = new ExtractHintDialog(this);
		RegisterDialog(m_hintExtractDialog);
		
		m_hintExtractDialog.SetInfo(strAccount, strMoney);
		m_hintExtractDialog.Show();
	}
	public void OnRequestComplete(int nRequestId, Requester req) {
		if (m_progressDialog != null) {
			m_progressDialog.dismiss();
			m_progressDialog = null;
		}
		
		if (req instanceof Request_ExtractPhoneBill){
			if (req.GetResult() == 0) {
				Request_ExtractPhoneBill extractReq = (Request_ExtractPhoneBill)req;
				String strOrderId = extractReq.GetOrderId();

				//请求完成, 更改余额
				WangcaiApp.GetInstance().ChangeBalance(-m_selectedSubItem.m_nRealPrice);

				ActivityHelper.ShowExtractSucceed(this, getString(R.string.extract_phonebill), strOrderId);
			}
			else {
				String strMsg = req.GetMsg();
				if (Util.IsEmptyString(strMsg)) {
					ActivityHelper.ShowToast(this, R.string.hint_request_error);
				}
				else {
					Util.ShowRequestErrorMsg(this, req.GetMsg());				
				}
			}
		}
	}
	
	private ExtractInfo.ExtractItem m_extractItem = null;
    private HintBindPhoneDialog m_bindPhoneDialog = null;
    private ExtractHintDialog m_hintExtractDialog = null;

    private ProgressDialog m_progressDialog = null;
    private ExtractInfo.ExtractSubItem m_selectedSubItem = null;
}

