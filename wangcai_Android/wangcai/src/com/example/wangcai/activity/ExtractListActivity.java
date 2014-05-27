package com.example.wangcai.activity;

import com.example.wangcai.R;
import com.example.wangcai.R.drawable;
import com.example.wangcai.R.id;
import com.example.wangcai.R.layout;
import com.example.wangcai.base.ActivityHelper;
import com.example.wangcai.base.WangcaiActivity;
import com.example.wangcai.ctrls.ExtraItem;

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
    	((Button)this.findViewById(R.id.task_detail)).setOnClickListener(new OnClickListener(){
    		public void onClick(View v) {
    			ActivityHelper.ShowDetailActivity(ExtractListActivity.this);
    		}
    	});
    	
    	ViewGroup parentView = (ViewGroup)this.findViewById(R.id.item_list);
    	AddItem(parentView, sg_strPhoneBill, R.drawable.extract_phone, "手机话费");
    	AddItem(parentView, sg_strAliPay, R.drawable.extract_alipay, "支付宝");
    	AddItem(parentView, sg_strQbi, R.drawable.extract_qbi, "腾讯Q币");
    }

    private void AddItem(ViewGroup parentView, String strItemName, int nIconId, String strName) {
    	ExtraItem item = new ExtraItem(strItemName);
    	item.SetItemEventLinstener(this);
    	View view = item.Create(getApplicationContext(), nIconId, strName);
    	parentView.addView(view);
    }
}



