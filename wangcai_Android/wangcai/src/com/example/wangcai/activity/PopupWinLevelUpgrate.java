package com.example.wangcai.activity;

import com.example.wangcai.R;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.PopupWindow;

public class PopupWinLevelUpgrate extends PopupWindow implements OnClickListener{


    public PopupWinLevelUpgrate(Activity holderActivity) {  
        super(holderActivity);
        m_ownerActivity = holderActivity;
        LayoutInflater inflater = (LayoutInflater) holderActivity  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        m_appWin = inflater.inflate(R.layout.win_level_upgrate, null);  

        this.setContentView(m_appWin);
        Resources r = m_ownerActivity.getResources(); 
        this.setWidth(ViewGroup.LayoutParams.MATCH_PARENT);  
        this.setHeight(ViewGroup.LayoutParams.MATCH_PARENT); 
        this.setFocusable(true);  
        //ColorDrawable dw = new ColorDrawable(0xffffff);  
        //this.setBackgroundDrawable(dw);  
  
        
    	m_appWin.findViewById(R.id.get_award_button).setOnClickListener(this);	        
    	m_appWin.findViewById(R.id.close_button).setOnClickListener(this);	        
    }  

    public void onClick(View v) {
    	int nId = v.getId();
    	if (nId == R.id.close_button) {
    		dismiss();
    	}
    }
    
    private Activity m_ownerActivity;
    private View m_appWin;
}