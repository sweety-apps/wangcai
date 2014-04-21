package com.example.wangcai;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.FrameLayout;

public class TitleCtrl extends FrameLayout {

	public interface TitleEvent{
		void OnRequestClose();
	}
	
    public TitleCtrl(Context context) {
        super(context);
        DoInit(context);
     }
    public TitleCtrl(Context context, AttributeSet attrs) {  
        super(context, attrs);  
        
        DoInit(context);
    }  
    public TitleCtrl(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);  
        
        DoInit(context);
    }  
  
    private void DoInit(Context context) {
        LayoutInflater inflater=(LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        inflater.inflate(R.layout.ctrl_title, this);
        

    	Button returnButton = (Button)this.findViewById(R.id.return_button);
    	if (returnButton != null) {
	    	returnButton.setOnClickListener(new OnClickListener() {
	            public void onClick(View v) {
	            	if (m_eventLinsterner != null) {
	            		m_eventLinsterner.OnRequestClose();
	            	}
	            }
	        });
    	}    		
    }

    public boolean SetEventLinstener(TitleEvent eventLinstener)
    {
    	m_eventLinsterner = eventLinstener;
    	
    	return true;    	
    }
 

    
    private TitleEvent m_eventLinsterner;
}
