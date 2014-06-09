package com.coolstore.wangcai.ctrls;

import java.lang.ref.WeakReference;

import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.wangcai.R;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.text.Html;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

public class ExtractPrieceCtrl extends LinearLayout implements View.OnClickListener{
	public interface ExtractPrieceCtrlEvent {
		void OnPriceClick(ExtractPrieceCtrl ctrl);
	}
    public ExtractPrieceCtrl(Context context) {
        super(context);
        DoInit(context);
     }
    public ExtractPrieceCtrl(Context context, AttributeSet attrs) {  
        this(context, attrs, 0); 
    }  
    @SuppressLint("NewApi") public ExtractPrieceCtrl(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);  
        DoInit(context);

        TypedArray typeArray = context.getTheme().obtainStyledAttributes(attrs, R.styleable.ExtractPrieceCtrl, 0, 0);
        int nIndexCount = typeArray.getIndexCount();  
        for (int i = 0; i < nIndexCount; i++) {  
            int attr = typeArray.getIndex(i);  
            switch (attr) {  
	            case R.styleable.ExtractPrieceCtrl_price:
	            	int nPriece = typeArray.getInt(attr, 0);
	            	SetPriece(nPriece);
	            	break;
	            case R.styleable.ExtractPrieceCtrl_off:
	            	int nOff = typeArray.getInt(attr, 0);
	            	SetDiscountMoney(nOff);
	            	break;
	            case R.styleable.ExtractPrieceCtrl_isHot:
	            	boolean bIsHot = typeArray.getBoolean(attr, false);
	            	SetIsHot(bIsHot);
	            	break;
            }
        }
    }
    public void SetEventListener(ExtractPrieceCtrlEvent event) {
    	m_eventListener = new WeakReference<ExtractPrieceCtrlEvent>(event);
    }
    public void onClick(View v) {
    	if (m_eventListener != null) {
    		ExtractPrieceCtrlEvent eventListener = m_eventListener.get();
    		if (eventListener != null) {
    			eventListener.OnPriceClick(this);
    		}
    	}
    }
    private void DoInit(Context context) {
        LayoutInflater inflater=(LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        inflater.inflate(R.layout.ctrl_extract_price_item, this);
        this.setOnClickListener(this);
    }
    public void SetPriece(int nPriece) {
    	TextView priceText = (TextView)this.findViewById(R.id.price);
    	String strText = String.format(getContext().getString(R.string.money_with_unit), Util.FormatMoney(nPriece));
    	priceText.setText(strText);
    	
    }
    public void SetDiscountMoney(int nDiscountMoney) {
    	if (nDiscountMoney <= 0) {
    		this.findViewById(R.id.off).setVisibility(View.GONE);
    	}
    	else {
    		TextView discountText = (TextView)this.findViewById(R.id.off);
	    	String strPattern = Html.fromHtml("·µÏÖ<font color=\"#ff0000\">%s</font>Ôª").toString();
	    	String strText = String.format(strPattern, Util.FormatMoney(nDiscountMoney));
	    	discountText.setHint(strText);
	    	discountText.setVisibility(View.VISIBLE);
    	}
    }
    public void SetIsHot(boolean bIsHot) {
    	if (bIsHot) {
    		ViewHelper.SetViewBackground(this, R.id.grid_bkg, R.drawable.extract_hot_bkg);
    	}
    	else {
    		ViewHelper.SetViewBackground(this, R.id.grid_bkg, R.drawable.extract_bkg);	            		
    	}    	
    }
    
    WeakReference<ExtractPrieceCtrlEvent> m_eventListener = null;
}
