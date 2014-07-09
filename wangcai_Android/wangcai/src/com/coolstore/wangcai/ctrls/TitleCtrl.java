package com.coolstore.wangcai.ctrls;

import java.lang.ref.WeakReference;

import com.coolstore.wangcai.R;

import android.app.Activity;
import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.TextView;

public class TitleCtrl extends FrameLayout {

	public interface TitleEvent{
		boolean OnRequestClose();	//return true表示close
	}
	
    public TitleCtrl(Context context) {
        super(context);
        DoInit(context);
     }
    public TitleCtrl(Context context, AttributeSet attrs) {  
        this(context, attrs, 0);  

    }  
    public TitleCtrl(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);  

        DoInit(context);
 
        TypedArray typeArray = context.getTheme().obtainStyledAttributes(attrs, R.styleable.TitleCtrl, 0, 0);
        int nIndexCount = typeArray.getIndexCount();  
        for (int i = 0; i < nIndexCount; i++) {  
            int attr = typeArray.getIndex(i);  
            switch (attr) {  
	            case R.styleable.TitleCtrl_titleText:
	            	String strText = typeArray.getString(attr);
	            	TextView titleText = (TextView)this.findViewById(R.id.titile_text);
	            	titleText.setText(strText);
	            	break;
	            case R.styleable.TitleCtrl_titleTextColor:
	            	int nColor = typeArray.getColor(attr, context.getResources().getColor(R.color.default_text_color));
	            	((TextView)this.findViewById(R.id.titile_text)).setTextColor(nColor);
	            	break;
	            case R.styleable.TitleCtrl_returnImg:
	            	int nResId = typeArray.getResourceId(attr, R.drawable.head_back);
	            	ImageButton button = (ImageButton)this.findViewById(R.id.return_button);
	            	button.setImageResource(nResId);
	            	break;
	            case R.styleable.TitleCtrl_bkgImg:
	            	int nBkgResId = typeArray.getResourceId(attr, R.drawable.nav_title);
	            	View view = this.findViewById(R.id.title_frame);
	            	view.setBackgroundResource(nBkgResId);
	            	break;
            }
        }
    }  
  

    private void DoInit(Context context) {
        LayoutInflater inflater=(LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        inflater.inflate(R.layout.ctrl_title, this);
        

    	View returnButton = this.findViewById(R.id.return_button);
    	if (returnButton != null) {
	    	returnButton.setOnClickListener(new OnClickListener() {
	            public void onClick(View v) {
	            	if (m_eventLinsterner != null) {
	            		TitleEvent eventListener = m_eventLinsterner.get();
	            		if (eventListener != null && eventListener.OnRequestClose()) {
							Finish();
						}
	            	}
					else {
						Finish();
					}
	            }
	        });
    	}    		
    }
	public void SetTitle(String strTitle) {
		TextView title = (TextView)findViewById(R.id.titile_text);
		title.setText(strTitle);
	}
	private void Finish() {
		Activity ownerActivity = null;
		Context context = getContext();
		if (context != null && context instanceof Activity)
		{
			ownerActivity = (Activity)context;
		}
		if (ownerActivity != null) {
			ownerActivity.finish();
		}
		if (m_eventLinsterner != null) {
			m_eventLinsterner.clear();
		}
	}

    public boolean SetEventLinstener(TitleEvent eventLinstener)
    {
    	m_eventLinsterner = new WeakReference<TitleEvent>(eventLinstener);    	
    	return true;    	
    }
 

    private WeakReference<TitleEvent> m_eventLinsterner = null;
}
