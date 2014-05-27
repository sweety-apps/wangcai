package com.example.wangcai.ctrls;

import com.example.common.ViewHelper;
import com.example.wangcai.R;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
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
        DoInit(context);
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
    	m_eventListener = event;
    }
    public void onClick(View v) {
    	if (m_eventListener != null) {
    		m_eventListener.OnPriceClick(this);
    	}
    }
    private void DoInit(Context context) {
        LayoutInflater inflater=(LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        inflater.inflate(R.layout.ctrl_extract_price_item, this);
        this.setOnClickListener(this);
    }
    public void SetPriece(int nPriece) {
    	TextView priceText = (TextView)this.findViewById(R.id.price);
    	priceText.setText(String.valueOf(nPriece));
    	
    }
    public void SetDiscountMoney(int nOffMoney) {
    	TextView discountText = (TextView)this.findViewById(R.id.off);
    	discountText.setHint(String.valueOf(nOffMoney));
    	discountText.setVisibility(View.VISIBLE);
    }
    public void SetIsHot(boolean bIsHot) {
    	if (bIsHot) {
    		ViewHelper.SetViewBackground(this, R.id.grid_bkg, R.drawable.extract_hot_bkg);
    	}
    	else {
    		ViewHelper.SetViewBackground(this, R.id.grid_bkg, R.drawable.extract_bkg);	            		
    	}    	
    }
    
    ExtractPrieceCtrlEvent m_eventListener = null;
}
