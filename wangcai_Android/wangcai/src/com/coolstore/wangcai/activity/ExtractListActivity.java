package com.coolstore.wangcai.activity;

import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.WangcaiApp;
import com.coolstore.wangcai.R.drawable;
import com.coolstore.wangcai.R.id;
import com.coolstore.wangcai.R.layout;
import com.coolstore.wangcai.base.ActivityHelper;
import com.coolstore.wangcai.base.WangcaiActivity;
import com.coolstore.wangcai.ctrls.ExtraItem;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ExtractListActivity extends WangcaiActivity implements ExtraItem.ExtractItemEvent{
	private final static String sg_strPhoneBill = "PhoneBill";
	private final static String sg_strAliPay = "AliPay";
	private final static String sg_strQbi = "Qbi";
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_extract);        

        InitView();
     }

 
    public void OnDoExtract(String strItemName) {
    	if (strItemName == sg_strPhoneBill) {
    		ActivityHelper.ShowExtractPhoneBillActivity(this);
    	}
    	else if (strItemName == sg_strAliPay) {
    		ActivityHelper.ShowExtractAliPayActivtiy(this);
    	}
    	else if (strItemName == sg_strQbi) {
    		ActivityHelper.ShowExtractQBiActivtiy(this);
    	}
    }

    private void InitView() {
    	View detail = this.findViewById(R.id.task_detail);
    	detail.setOnClickListener(new OnClickListener(){
    		public void onClick(View v) {
    			ActivityHelper.ShowDetailActivity(ExtractListActivity.this);
    		}
    	});

    	ViewHelper.SetStateViewBkg(detail, this, R.drawable.jiaoyi, R.drawable.jiaoyi_sel);
    	
    	int nBalance = WangcaiApp.GetInstance().GetUserInfo().GetBalance();
    	String strText = String.format(getString(R.string.usable_balance), Util.FormatMoney(nBalance));
    	ViewHelper.SetTextStr(this, R.id.balance, strText);
   
    	ViewGroup parentView = (ViewGroup)this.findViewById(R.id.item_list);
    	AddItem(parentView, sg_strPhoneBill, R.drawable.extract_phone, "�ֻ�����");
    	AddItem(parentView, sg_strAliPay, R.drawable.extract_alipay, "֧����");
    	AddItem(parentView, sg_strQbi, R.drawable.extract_qbi, "��ѶQ��");
    }

    private void AddItem(ViewGroup parentView, String strItemName, int nIconId, String strName) {
    	ExtraItem item = new ExtraItem(strItemName);
    	item.SetItemEventLinstener(this);
    	View view = item.Create(getApplicationContext(), nIconId, strName);
    	parentView.addView(view);
    }
}



