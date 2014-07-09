package com.coolstore.wangcai.activity;

import com.coolstore.common.Util;
import com.coolstore.common.ViewHelper;
import com.coolstore.wangcai.R;
import com.coolstore.wangcai.base.ActivityHelper;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.PopupWindow;

public class PopupWinLevelUpgrate extends PopupWindow implements OnClickListener{


    public PopupWinLevelUpgrate(Activity holderActivity, int nLevel, int nLevelChange) {  
        super(holderActivity);
        m_ownerActivity = holderActivity;
        LayoutInflater inflater = (LayoutInflater) holderActivity  
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);  
        m_appWin = inflater.inflate(R.layout.win_level_upgrate, null);  

        this.setContentView(m_appWin);
        //Resources r = m_ownerActivity.getResources(); 


        this.setWidth(ViewGroup.LayoutParams.FILL_PARENT);  
        this.setHeight(ViewGroup.LayoutParams.FILL_PARENT); 
        this.setFocusable(true); 
        this.setBackgroundDrawable(holderActivity.getResources().getDrawable(R.drawable.popup_bkg));
        
        String strText = String.format(holderActivity.getString(R.string.level_value_label), nLevel);
        ViewHelper.SetTextStr(m_appWin, R.id.level, strText);
        
    	m_appWin.findViewById(R.id.show_level).setOnClickListener(this);	        
    	m_appWin.findViewById(R.id.close_button).setOnClickListener(this);	  
    	m_appWin.findViewById(R.id.sys_close_button).setOnClickListener(this);	 
    	
    	String strSkill = "";
    	if (nLevel == 3) {
    		strSkill = holderActivity.getString(R.string.skill3);
    	}
    	else if (nLevel == 5) {
    		strSkill = holderActivity.getString(R.string.skill5);
    	}
    	else if (nLevel == 10) {
    		strSkill = holderActivity.getString(R.string.skill10);
    	}
    	if (Util.IsEmptyString(strSkill)) {
    		m_appWin.findViewById(R.id.new_skill_label).setVisibility(View.GONE);
    		m_appWin.findViewById(R.id.new_skill_text).setVisibility(View.GONE);
    	}
    	else {
    		ViewHelper.SetTextStr(m_appWin, R.id.new_skill_text, strSkill);
    	}

    	ViewHelper.SetTextStr(m_appWin, R.id.addition_percent_text, String.format("%d%%", nLevel));
    	
    	if (nLevelChange <= 0) {
    		m_appWin.findViewById(R.id.award_label).setVisibility(View.GONE);
    		m_appWin.findViewById(R.id.award_text).setVisibility(View.GONE);    		
    	}
    	else {
    		strText = String.format(holderActivity.getString(R.string.money_with_unit), Util.FormatMoney(nLevelChange));
        	ViewHelper.SetTextStr(m_appWin, R.id.award_text, strText);
    	}
    }  

    public void onClick(View v) {
    	int nId = v.getId();
    	if (nId == R.id.close_button || nId == R.id.sys_close_button) {
    		dismiss();
    	}
    	else if (nId == R.id.show_level) {
    		dismiss();
    		ActivityHelper.ShowMyWnagcaiActivity(m_ownerActivity);
    	}
    }
    
    private Activity m_ownerActivity = null;
    private View m_appWin = null;
}